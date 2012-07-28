should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

boiler 'Service - Invite Operator', ->
  beforeEach (done) ->
    # create a new chat
    @newChat =>

      # log in as an operator
      loginData =
        email: 'guru1@foo.com'
        password: 'foobar'
      client = @getClient()
      client.ready =>
        client.login loginData, (err) =>
          throw new Error err if err

          # get the session
          @targetSession = client.cookie 'session'
          client.disconnect()

          # log in another operator
          @getAuthed =>

            # accept the chat
            @client.acceptChat @channelName, (err) =>
              should.not.exist err
              done()

  it "should let you invite an operator to the chat", (done) ->

    # Try to invite other operator
    @client.inviteOperator @targetSession, @channelName, (err) =>
      should.not.exist err

      # Check whether operator was invited
      # TODO: once they're updated, use accept invite or getActiveChats to test this instead
      {ChatSession} = redgoose.models
      ChatSession.getByChat @channelName, (err, chatSessions) =>
        should.not.exist err
        for cs in chatSessions when cs.sessionId is @targetSession
          chatSession = cs

          chatSession.relationMeta.get 'type', (err, type) =>
            type.should.eql 'invite'
            chatSession.relationMeta.get 'requestor', (err, requestor) =>
              requestor.should.eql @client.cookie 'session'
              done()

  it "should notify the operator you invited", (done) ->

    # Should receive notification
    recipient = @getPulsar().channel "notify:session:#{@targetSession}"
    recipient.on 'chatInvites', ([chat]) ->
      should.exist chat
      done()

    # Try to invite other operator
    @client.inviteOperator @targetSession, @channelName, (err) =>
      should.not.exist err
