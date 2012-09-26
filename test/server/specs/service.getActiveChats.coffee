should = require 'should'
stoic = require 'stoic'

boiler 'Service - Get Active Chats', ->

  it 'should return data on all existing chats', (done) ->
    @getAuthed =>
      @newChat =>

        # get active chats
        @client.getActiveChats (err, [chatData]) =>
          should.not.exist err
          should.exist chatData, 'expected a chat record'
          chatData.visitor.username.should.eql 'visitor'
          chatData.status.should.eql 'waiting'
          should.exist new Date chatData.creationDate

          @client.disconnect()
          done()

  it 'should return operators for chats', (done) ->
    @getAuthed =>
      @newChat =>

        # have our operator join the chat
        @client.joinChat @chatChannelName, =>

          # get active chats
          @client.getActiveChats (err, [chatData]) =>
            should.not.exist err
            should.exist chatData.operators
            chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'

            @client.disconnect()
            done()

  it 'should return operators for chats', (done) ->
    chatData =
      username: 'visitor'
      department: 'foo'
      referrerData: JSON.stringify {websiteUrl: 'foo.com'}

    @guru3Login (err, @client) =>
      @newChatWith chatData, =>

        # get active chats
        @client.getActiveChats (err, [chatData]) =>
          should.exist chatData.operators
          chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'

          @client.disconnect()
          done()

  it 'should sort the chats', (done) ->
    @getAuthed =>
      session = @client.cookie 'session'
      @createChats (err, chats) =>

        # add an invite for the present operator
        inviteChat = chats[2]
        {ChatSession} = stoic.models
        ChatSession.add session, inviteChat.id, {type: 'invite'}, =>

          # get active chats
          @client.getActiveChats (err, chats) =>
            should.not.exist err
            should.exist chats
            chats.length.should.eql 4

            visitorNames = chats.map (chat) => chat.visitor.username
            visitorNames.should.eql ['Ralph', 'Bob', 'Suzie', 'Frank']

            @client.disconnect()
            done()

  it "should have a chat relation based on whether an operator is invited", (done) ->
    getActiveChats = config.require 'services/getActiveChats'

    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @chatChannelName, (err) =>
            should.not.exist err
            @client.inviteOperator @chatChannelName, @targetSession, (err) =>
              should.not.exist err

              # Do test
              getActiveChatsRes =
                cookie: (string) => @targetSession
                reply: (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatChannelName
                  chats[0].relation.should.eql 'invite'
                  done()

              getActiveChats getActiveChatsRes
