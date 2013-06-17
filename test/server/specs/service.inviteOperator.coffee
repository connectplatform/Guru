should = require 'should'

db = config.require 'load/mongo'
{ChatSession} = db.models

boiler 'Service - Invite Operator', ->
  beforeEach ->

    # create invitee
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

  it "should let you invite an operator to the chat", (done) ->
    @prep =>
      # Try to invite other operator
      @client.inviteOperator {@chatId, @targetSessionId}, (err) =>
        should.not.exist err, 'expected inviteOperator to not error'

        # Check whether operator was invited
        # TODO: test this on the server level, rather than querying db directly
        ChatSession.findOne {@chatId, sessionId: @targetSessionId}, (err, chatSession) =>
          should.not.exist err
          should.exist chatSession
          
          chatSession.relation.should.equal 'Invite'
          chatSession.initiator.should.equal @sessionId
          done()

  it "should not let you invite an operator to a nonexistent chat", (done) ->
    @prep =>
      badChatId = @targetSessionId # sic
      @client.inviteOperator {chatId: badChatId, @targetSessionId}, (err) =>
        should.exist err
        done()

  it "should not let you invite yourself to a Chat", (done) ->
    @prep =>
      # Try to invite myself
      @client.inviteOperator {@chatId, targetSessionId: @sessionId}, (err) =>
        should.exist err
        err.should.equal 'sessionId and targetSessionId cannot be the same.'
        done()

  it "should not let you invite a Visitor to a Chat", (done) ->
    @prep =>
      client = @client
      chatId = @chatId
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor) =>
        should.not.exist err
        should.exist visitor
        visitorSessionId = visitor.localStorage.sessionId
        @client.inviteOperator {chatId: chatId, targetSessionId: visitorSessionId}, (err) =>
          should.exist err
          err.should.equal 'You cannot invite a Visitor to join a Chat'
          done()

                              
# This should be a separate integration test
  # it "should notify the operator you invited", (done) ->
  #   @prep =>
  #     sessionUpdates = "notify:session:#{@targetSession}"

  #     # Should receive notification
  #     recipient = @getPulsar().channel sessionUpdates
  #     recipient.once 'pendingInvites', ([chat]) ->
  #       should.exist chat
  #       done()

  #     recipient.ready =>

  #       # Try to invite other operator
  #       @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, ->
