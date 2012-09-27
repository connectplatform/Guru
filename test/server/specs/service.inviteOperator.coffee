should = require 'should'
stoic = require 'stoic'
Pulsar = require 'pulsar'

boiler 'Service - Invite Operator', ->
  beforeEach (done) ->
    # create a new chat
    @newChat =>

      # create invitee
      client = @getClient()
      client.ready =>
        client.login @guru1Login, (err) =>
          throw new Error err if err

          # get the invitee's session
          @targetSession = client.cookie 'session'
          client.disconnect()

          # create inviter
          @getAuthed =>

            # accept the chat
            @client.acceptChat @chatId, (err) =>
              should.not.exist err
              done()

  it "should let you invite an operator to the chat", (done) ->

    # Try to invite other operator
    @client.inviteOperator @chatId, @targetSession, (err) =>
      should.not.exist err

      # Check whether operator was invited
      # TODO: once they're updated, use accept invite or getActiveChats to test this instead
      {ChatSession} = stoic.models
      ChatSession.getByChat @chatId, (err, chatSessions) =>
        should.not.exist err
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
    recipient.on 'newInvites', ([chat]) ->
      should.exist chat
      done()

    recipient.ready =>

      # Try to invite other operator
      @client.inviteOperator @chatId, @targetSession, (err) =>
        should.not.exist err
