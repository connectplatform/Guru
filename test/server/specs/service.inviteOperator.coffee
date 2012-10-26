should = require 'should'
stoic = require 'stoic'
Pulsar = require 'pulsar'

boiler 'Service - Invite Operator', ->
  beforeEach (done) ->

    # create invitee
    @guru1Login (err, @guru1, @accountId) =>
      throw new Error err if err

      # get the invitee's session
      @targetSession = @guru1.cookie 'session'

      # create inviter
      @getAuthed =>

        # create a new chat
        @newChat (err, data) =>
          should.not.exist err

          # accept the chat
          @client.acceptChat {chatId: @chatId}, (err) =>
            should.not.exist err
            done()

  afterEach ->
    @guru1.disconnect()

  it "should let you invite an operator to the chat", (done) ->

    # Try to invite other operator
    @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
      should.not.exist err

      # Check whether operator was invited
      # TODO: test this on the server level, rather than querying db directly
      {ChatSession} = stoic.models
      ChatSession(@accountId).getByChat @chatId, (err, chatSessions) =>
        should.not.exist err

        # get the chatSession we care about
        chatSession = {}
        for cs in chatSessions when cs.sessionId is @targetSession
          chatSession = cs

        chatSession.relationMeta.get 'type', (err, type) =>
          type.should.eql 'invite'
          chatSession.relationMeta.get 'requestor', (err, requestor) =>
            requestor.should.eql @client.cookie 'session'
            done()

  it "should notify the operator you invited", (done) ->

    sessionUpdates = "notify:session:#{@targetSession}"

    # Should receive notification
    recipient = @getPulsar().channel sessionUpdates
    recipient.on 'pendingInvites', ([chat]) ->
      should.exist chat
      done()

    recipient.ready =>

      # Try to invite other operator
      @client.inviteOperator {chatId: @chatId, targetSessionId: @targetSession}, (err) =>
        should.not.exist err
