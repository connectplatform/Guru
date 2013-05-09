should = require 'should'
async = require 'async'
sugar = require 'sugar'
db = config.require 'load/mongo'

createChat = (accountId) ->
  (chat, cb) ->
    {Chat} = stoic.models
    Chat(accountId).create (err, c) ->
      should.not.exist err

      async.parallel [
        c.visitor.mset chat.visitor
        c.status.set chat.status
        c.creationDate.set chat.creationDate
      ], (err) ->
        should.not.exist err

        pushHistory = (historyItem, cb) ->
          c.history.rpush historyItem, cb

        async.forEach chat.history, pushHistory, (err) ->
          should.not.exist err

          cb null, c

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

  beforeEach (done) ->
    {Account} = db.models
    Account.findOne {}, {_id: true}, (err, account) =>
      @accountId = account._id
      done()

  it 'should delete old chats', (done) ->
    {Chat} = stoic.models

    async.map getOldChats(halfHourAgo, almostHalfHourAgo), createChat(@accountId), (err, chats) =>

      [chat1, chat2] = chats.map 'id'
      @clearOldChats (err) =>
        should.not.exist err, "clearOldChats threw an error:#{err}"
        Chat(@accountId).allChats.members (err, allChats) ->
          should.not.exist err, "allChats threw an error:#{err}"
          allChats.length.should.eql 0, 'expected old chats to be deleted'

          # check redis keys directly
          redis = stoic.client
          redis.keys "*#{chat1}*", (err, keys) ->
            keys.should.be.empty
            redis.keys "*#{chat2}*", (err, keys) ->
              keys.should.be.empty
              done()

  it 'should not delete new chats', (done) ->
    {Chat} = stoic.models

    async.map getOldChats(now, now), createChat(@accountId), (err) =>

      @clearOldChats (err) =>
        should.not.exist err
        Chat(@accountId).allChats.members (err, allChats) ->
          should.not.exist err
          allChats.length.should.eql 2, 'expected new chats to stay'
          done()

  it 'should let a visitor create a new chat if their old one was deleted', (done) ->
    {Chat} = stoic.models

    # create the chat
    @getAuthed =>
      visitor = @getClient()
      visitor.ready =>
        newChatData = {username: 'visitor', websiteUrl: 'foo.com'}
        visitor.newChat newChatData, (err, {chatId, sessionId}) =>
          should.not.exist err
          visitorSession = sessionId

          # modify the chat's creation date
          Chat(@accountId).get(chatId).creationDate.set halfHourAgo, (err) =>
            should.not.exist err

            # delete the chat
            @clearOldChats (err) =>
              should.not.exist err

              # Chat should delete, even with user in it
              Chat(@accountId).allChats.members (err, allChats) =>
                should.not.exist err
                allChats.length.should.eql 0

                # Create a new chat and make sure it's different than the one we had
                visitor.newChat newChatData, (err, newChat) ->
                  should.not.exist err
                  visitorSession.should.not.eql newChat.sessionId
                  chatId.should.not.eql newChat.chatId
                  done()

  testWithSessions = (method) ->
    describe "with operator sessions (#{method})", ->
      beforeEach (done) ->
        @getAuthed =>
          async.map getOldChats(halfHourAgo, halfHourAgo), createChat(@accountId), (err, chats) =>
            chatId = chats[0].id

            # joinChat/watchChat
            @client[method] {sessionId: @sessionId, chatId: chatId}, (err, results) =>
              should.not.exist err
              done()

      it 'should show me as joined', (done) ->
        @client.getMyChats {}, (err, {chats}) =>
          should.not.exist err
          chats.length.should.eql 1, 'chat should exist'
          done()

      it 'should remove operators from the deleted chats', (done) ->
        {Chat} = stoic.models

        # delete the chat
        @clearOldChats (err) =>
          should.not.exist err
          Chat(@accountId).allChats.members (err, allChats) =>
            should.not.exist err
            allChats.length.should.eql 0, 'all chats should be empty'

            # check that operator was properly removed
            @client.getMyChats {}, (err, {chats}) =>
              should.not.exist err
              chats.length.should.eql 0, 'my chat sessions should be empty'
              done()

      it 'should save a history', (done) ->
        {ChatHistory} = db.models

        # delete the chat
        @clearOldChats (err) =>
          should.not.exist err
          ChatHistory.find {accountId: @accountId}, (err, history) =>
            should.not.exist err
            should.exist history
            history.length.should.eql 3, 'should have 3 history records'
            done()

  testWithSessions 'joinChat'
  testWithSessions 'watchChat'
