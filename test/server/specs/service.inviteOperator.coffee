should = require 'should'

boiler 'Service - Invite Operator', ->
  beforeEach ->

    # create invitee
    @prep = (next) ->
      @guru1Login (err, @guru1, {accountId, sessionId}) =>
        should.not.exist err, 'expected login not to error'

        # get the invitee's session
        @accountId = accountId
        @targetSession = sessionId

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
    console.log 'HERE'
    @prep =>

      # Try to invite other operator
      @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
        should.not.exist err, 'expected inviteOperator to not error'

        # Check whether operator was invited
        # TODO: test this on the server level, rather than querying db directly
        {ChatSession} = stoic.models
        ChatSession(@accountId).getByChat @chatId, (err, chatSessions) =>
          should.not.exist err, 'expected ChatSession.getByChat to not error'

          # get the chatSession we care about
          chatSession = {}
          for cs in chatSessions when cs.sessionId is @targetSession
            chatSession = cs

          chatSession.relationMeta.get 'type', (err, type) =>
            type.should.eql 'invite'
            chatSession.relationMeta.get 'requestor', (err, requestor) =>
              requestor.should.eql @sessionId
              done()

  it "should notify the operator you invited", (done) ->
    @prep =>

      sessionUpdates = "notify:session:#{@targetSession}"

      # Should receive notification
      recipient = @getPulsar().channel sessionUpdates
      recipient.once 'pendingInvites', ([chat]) ->
        should.exist chat
        done()

      recipient.ready =>

        # Try to invite other operator
        @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, ->
