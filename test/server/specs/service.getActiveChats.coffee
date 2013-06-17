should = require 'should'
db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Get Active Chats', ->

  it 'should return data on all existing chats', (done) ->
    @getAuthed =>
      @newChat =>

        # get active chats
        @client.getActiveChats {}, (err, {chats: [chat]}) =>
          should.not.exist err
          should.exist chat, 'expected a chat record'
          chat.formData.username.should.equal 'visitor'
          chat.status.should.equal 'Waiting'
          done()

  # This is no longer true, as operators is no longer part of the schema
  # it 'should return operators for chats', (done) ->
  #   @getAuthed =>
  #     @newChat =>

  #       # have our operator join the chat
  #       @client.joinChat {chatId: @chatId}, =>

  #         # get active chats
  #         @client.getActiveChats {}, (err, {chats: [chatData]}) =>
  #           should.not.exist err
  #           should.exist chatData.operators
  #           chatData.operators.length.should.eql 1, 'Expected 1 operator in chat'
  #           done()

  describe 'filter:', ->
    before ->
      @generate = (data, done) =>
        @guru3Login (err, @client) =>
          @newChatWith data, (err, chatData) =>
            # get active chats
            @client.getActiveChats {}, (err, {chats}) =>
              should.not.exist err
              should.exist chats
              done err, chats

    it 'should not show me chats for another website', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'baz.com'

      @generate chatData, (err, chats) ->
        chats.length.should.equal 0, 'Expected no chats'
        done()

    it 'should show me chats for my website', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'

      @generate chatData, (err, chats) ->
        chats.length.should.equal 1, 'Expected a chat'
        done()

    it 'should not show me chats for another specialty', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        specialtyName: 'Billing'

      @generate chatData, (err, chats) ->
        chats.length.should.equal 0, 'Expected no chats'
        done()

    it 'should show me chats for my specialty', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        specialtyName: 'Sales'

      @generate chatData, (err, chats) ->
        chats.length.should.equal 1, 'Expected a chat'
        done()

    it 'specialtyName should not be case sensitive', (done) ->
      chatData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        specialtyName: 'sales'

      @generate chatData, (err, chats) ->
        chats.length.should.equal 1, 'Expected a chat'
        done()

  it 'should not display any chats with vacant status', (done) ->
    @getAuthed =>
      @createChats (err, chats) =>
        should.not.exist err
        @client.getActiveChats {}, (err, {chats}) =>
          should.not.exist err
          should.exist chats
          vacantChats = [c for c in chats].filter ((c) -> c.status is 'Vacant')
          vacantChats.should.be.empty
          done()

  it 'should sort the chats', (done) ->
    @getAuthed (_..., {@sessionId, accountId}) =>
      @createChats (err, chats) =>
        should.not.exist err
        should.exist chats

        # add an invite for the present operator
        inviteChat = chats[2]
        ChatSession.create {@sessionId, chatId: inviteChat._id, relation: 'Invite'}, (err, _) =>
          should.not.exist err
          should.exist _
          
          ChatSession.findOne {@sessionId, chatId: inviteChat._id}, (err, chatSession) =>
            should.not.exist err
            should.exist chatSession, 'expected chatSession'
            
            ChatSession.find {@sessionId}, (err, chatSessions) =>
              should.not.exist err
              should.exist chatSessions

              # get active chats
              @client.getActiveChats {}, (err, {chats}) =>
                should.not.exist err
                should.exist chats
                chats.length.should.eql 3

                visitorNames = chats.map (chat) => chat.formData.username
                visitorNames.should.eql ['Bob', 'Suzie', 'Ralph']
                done()

  it "should have a chat relation if an operator is invited", (done) ->
    # Setup
    @loginOperator (err, invitee) =>
      @getAuthed =>
        @newChat =>
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err

            @client.inviteOperator {@chatId, @targetSessionId}, (err) =>
              should.not.exist err

              invitee.getActiveChats {sessionId: @targetSessionId}, (err, {chats}) =>
                should.not.exist err
                should.exist chats
                chats.length.should.eql 1
                [chat] = chats
                should.exist chat
                chat._id.should.equal @chatId
                chat.status.should.equal 'Active'
                cond =
                  chatId: @chatId
                  sessionId: @targetSessionId
                ChatSession.findOne cond, (err, chatSession) =>
                  should.not.exist err
                  should.exist.chatSession
                  chatSession.relation.should.equal 'Invite'
                  done()
