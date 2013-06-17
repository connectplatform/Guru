should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Transfer Chat', ->
  beforeEach ->
    @prep = (next) ->
      @guru1Login (err, @guru1, {accountId, sessionId}) =>
        should.not.exist err, 'expected login not to error'

        # get the invitee's session
        @accountId = accountId
        @targetSessionId = sessionId

        # create inviter
        @getAuthed =>

          # create a new chat
          @newChat (err, data) =>
            should.not.exist err, 'expected newChat to not error'

            # accept the chat
            @client.acceptChat {chatId: @chatId}, (err) =>
              should.not.exist err, 'expected acceptChat to not error'
              next()
              
  it "should let you transfer a chat to another operator", (done) ->
    @prep =>
      @client.transferChat {chatId: @chatId, targetSessionId: @targetSessionId}, (err) =>
        should.not.exist err

        # Check whether transfer worked
        ChatSession.findOne {@chatId, sessionId: @targetSessionId}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession
          chatSession.relation.should.equal 'Transfer'
          chatSession.initiator.should.equal @sessionId
          done()

  it "should not let you send an operator a transfer request to a nonexistent chat", (done) ->
    @prep =>
      badChatId = @targetSessionId # sic
      @client.transferChat {chatId: badChatId, @targetSessionId}, (err) =>
        should.exist err
        done()

  it "should not let you invite yourself to a Chat", (done) ->
    @prep =>
      # Try to invite myself
      @client.transferChat {@chatId, targetSessionId: @sessionId}, (err) =>
        should.exist err
        err.should.equal 'sessionId and targetSessionId cannot be the same.'
        done()

  it "should not let you send a Transfer request to a Visitor", (done) ->
    @prep =>
      client = @client
      chatId = @chatId
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor) =>
        should.not.exist err
        should.exist visitor
        visitorSessionId = visitor.localStorage.sessionId
        @client.transferChat {chatId: chatId, targetSessionId: visitorSessionId}, (err) =>
          should.exist err
          err.should.equal 'You cannot send a transfer request to a Visitor'
          done()