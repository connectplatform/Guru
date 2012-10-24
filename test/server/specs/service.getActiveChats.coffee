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
        @client.joinChat @chatId, =>

          # get active chats
          @client.getActiveChats (err, [chatData]) =>
            should.not.exist err
            should.exist chatData.operators
            chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'

            @client.disconnect()
            done()

  describe 'filter:', ->
    before ->
      @generate = (chatData, done) =>
        @guru3Login (err, @client) =>
          @newChatWith chatData, =>

            # get active chats
            @client.getActiveChats (err, chats) =>
              should.not.exist err
              should.exist chats

              @client.disconnect()
              done err, chats

    it 'should not show me chats for another website', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'baz.com'

      @generate chatData, (err, chats) ->
        chats.length.should.eql 0, 'Expected no chats'
        done()

    it 'should show me chats for my website', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'

      @generate chatData, (err, chats) ->
        chats.length.should.eql 1, 'Expected a chat'
        done()

    it 'should not show me chats for another specialty', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        department: 'Billing'

      @generate chatData, (err, chats) ->
        chats.length.should.eql 0, 'Expected a chat'
        done()

    it 'should show me chats for my specialty', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        department: 'Sales'

      @generate chatData, (err, chats) ->
        chats.length.should.eql 1, 'Expected a chat'
        done()

    it 'department should not be case sensitive', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        department: 'sales'

      @generate chatData, (err, chats) ->
        chats.length.should.eql 1, 'Expected a chat'
        done()

  it 'should sort the chats', (done) ->
    @getAuthed (_..., accountId) =>
      session = @client.cookie 'session'
      @createChats (err, chats) =>

        # add an invite for the present operator
        inviteChat = chats[2]
        {ChatSession} = stoic.models
        ChatSession(accountId).add session, inviteChat.id, {type: 'invite'}, =>

          # get active chats
          @client.getActiveChats (err, chats) =>
            should.not.exist err
            should.exist chats
            chats.length.should.eql 4

            visitorNames = chats.map (chat) => chat.visitor.username
            visitorNames.should.eql ['Ralph', 'Bob', 'Suzie', 'Frank']

            @client.disconnect()
            done()

  it "should have a chat relation if an operator is invited", (done) ->
    getActiveChats = config.require 'services/getActiveChats'

    # Setup
    @loginOperator =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat @chatId, (err) =>
            should.not.exist err
            @client.inviteOperator @chatId, @targetSession, (err) =>
              should.not.exist err

              # Do test
              getActiveChatsRes =
                cookie: (string) => @targetSession
                reply: (err, chats) =>
                  should.not.exist err
                  chats.length.should.eql 1
                  chats[0].id.should.eql @chatId
                  chats[0].relation.should.eql 'invite'
                  done()

              getActiveChats getActiveChatsRes
