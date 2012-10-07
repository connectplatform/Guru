should = require 'should'
stoic = require 'stoic'
async = require 'async'
sugar = require 'sugar'
mongo = config.require 'load/mongo'

createChat = (chat, cb) ->
  {Chat} = stoic.models
  Chat.create (err, c) ->
    async.parallel [
      c.visitor.mset chat.visitor
      c.status.set chat.status
      c.creationDate.set chat.creationDate
    ], (err) ->

      pushHistory = (historyItem, cb) ->
        c.history.rpush historyItem, cb

      async.forEach chat.history, pushHistory, ->
        cb err, c

getOldChats = (creation, firstChat) ->
  return [
    {
      visitor:
        username: 'Bob'
      status: 'waiting'
      creationDate: creation
      history: []
    }
    {
      visitor:
        username: 'Frank'
      status: 'vacant'
      creationDate: creation
      history: [
        {
          message: 'Hi'
          username: 'person'
          timestamp: firstChat
        }
      ]
    }
  ]

now = Date.create()
halfHourAgo = Date.create("30 minutes ago")
almostHalfHourAgo = Date.create("29 minutes ago")

boiler 'Service - Clear Old Chats', ->
  before ->
    @clearOldChats = config.require 'services/clearOldChats'

  it 'should delete old chats', (done) ->
    {Chat} = stoic.models

    async.map getOldChats(halfHourAgo, almostHalfHourAgo), createChat, =>
      @clearOldChats (err) ->
        should.not.exist err, "clearOldChats threw an error:#{err}"
        Chat.allChats.members (err, allChats) ->
          should.not.exist err, "allChats threw an error:#{err}"
          allChats.length.should.eql 0
          done()

  it 'should not delete new chats', (done) ->
    {Chat} = stoic.models

    async.map getOldChats(now, now), createChat, =>
      @clearOldChats (err) ->
        should.not.exist err
        Chat.allChats.members (err, allChats) ->
          should.not.exist err
          allChats.length.should.eql 2
          done()

  it 'should let a visitor create a new chat if their old one was deleted', (done) ->
    {Chat} = stoic.models

    # create the chat
    @getAuthed =>
      visitor = @getClient()
      visitor.ready =>
        newChatData = {username: 'visitor', websiteUrl: 'foo.com'}
        visitor.newChat newChatData, (err, createdChat) =>
          should.not.exist err
          visitorSession = visitor.cookie 'session'
          chatChannelName = createdChat.chatId

          # modify the chat's creation date
          chat = Chat.get chatChannelName
          chat.creationDate.set halfHourAgo, (err) =>
            should.not.exist err

            # delete the chat
            @clearOldChats (err) =>
              should.not.exist err

              # Chat should delete, even with user in it
              Chat.allChats.members (err, allChats) =>
                should.not.exist err
                allChats.length.should.eql 0

                # Create a new chat and make sure it's different than the one we had
                visitor.newChat newChatData, (err, createdChat) ->
                  should.not.exist err
                  visitorSession.should.not.eql visitor.cookie 'session'
                  chatChannelName.should.not.eql createdChat.chatId
                  done()

  describe 'with operator sessions', ->
    beforeEach (done) ->
      async.map getOldChats(halfHourAgo, halfHourAgo), createChat, (err, chats) =>
        chatId = chats[0].id

        # make sure user has properly joined chat
        @getAuthed =>
          @client.joinChat chatId, (err) =>
            should.not.exist err
            done()

    it 'should show me as joined', (done) ->
      @client.getMyChats (err, chats) =>
        should.not.exist err
        chats.length.should.eql 1, 'chat should exist'
        done()

    it 'should remove operators from the deleted chats', (done) ->
      {Chat} = stoic.models

      # delete the chat
      @clearOldChats (err) =>
        should.not.exist err
        Chat.allChats.members (err, allChats) =>
          should.not.exist err
          allChats.length.should.eql 0, 'all chats should be empty'

          # check that operator was properly removed
          @client.getMyChats (err, chats) =>
            should.not.exist err
            chats.length.should.eql 0, 'my chat sessions should be empty'
            done()

    it 'should save a history', (done) ->
      {ChatHistory} = mongo.models

      # delete the chat
      @clearOldChats (err) =>
        should.not.exist err
        ChatHistory.find {}, (err, history) =>
          should.not.exist err
          should.exist history
          history.length.should.eql 2, 'should have 2 history records'
          done()
