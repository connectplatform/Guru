should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Active Chats', ->

  it 'should return data on all existing chats', (done) ->
    @newChat =>
      @getAuthed =>

        # get active chats
        @client.getActiveChats (err, [chatData]) ->
          should.not.exist err
          chatData.visitor.username.should.eql 'visitor'
          chatData.status.should.eql 'waiting'
          new Date chatData.creationDate #just need this to not cause an error
          done()

  it 'should return operators for chats', (done) ->
    @newChat =>
      @getAuthed =>

        # have our operator join the chat
        @client.joinChat @chatChannelName, =>

          # get active chats
          @client.getActiveChats (err, [chatData]) ->
            should.not.exist err
            should.exist chatData.operators
            chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'

            done()

  it 'should sort the chats', (done) ->
    @createChats (err, chats) =>
      @getAuthed =>

        # add an invite for the present operator
        inviteChat = chats[2]
        {ChatSession} = stoic.models
        ChatSession.add @client.cookie('session'), inviteChat.id, {type: 'invite'}, =>

          # get active chats
          @client.getActiveChats (err, chats) ->
            should.not.exist err
            should.exist chats
            chats.length.should.eql 4

            visitorNames = chats.map (chat) -> chat.visitor.username
            visitorNames.should.eql ['Ralph', 'Bob', 'Suzie', 'Frank']

            done()
