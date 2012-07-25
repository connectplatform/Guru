should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

beforeEach (done) ->
  @loginOperator = (cb) =>
    loginData =
      email: 'guru1@torchlightsoftware.com'
      password: 'foobar'
    client = @getClient()
    client.ready =>
      client.login loginData, (err) =>
        throw new Error err if err
        @targetSession = client.cookie 'session'
        client.disconnect()
        cb()
  done()

boiler 'Service - Invite Operator', ->
  it "should let you invite an operator to the chat", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @channelName, (err) =>
            should.not.exist err

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
