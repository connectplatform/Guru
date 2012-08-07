should = require 'should'
boiler = require './util/boilerplate'
redgoose = require 'redgoose'

beforeEach (done) ->
  @loginOperator = (cb) =>
    loginData =
      email: 'guru1@foo.com'
      password: 'foobar'
    client = @getClient()
    client.ready =>
      client.login loginData, (err) =>
        throw new Error err if err
        @targetSession = client.cookie 'session'
        client.disconnect()
        cb()
  done()

boiler 'Service - Transfer Chat', ->
  it "should let you transfer a chat to another operator", (done) ->
    # Setup
    @newChat =>
      @loginOperator =>
        @getAuthed =>
          @client.acceptChat @channelName, (err) =>
            should.not.exist err

            # Try to transfer
            @client.transferChat @channelName, @targetSession, (err) =>
              should.not.exist err

              # Check whether transfer worked
              # TODO: once it's updated, use getActiveChats to test this instead
              {ChatSession} = redgoose.models
              ChatSession.getByChat @channelName, (err, chatSessions) =>
                should.not.exist err
                for cs in chatSessions when cs.sessionId is @targetSession
                  chatSession = cs

                  chatSession.relationMeta.get 'type', (err, type) =>
                    type.should.eql 'transfer'
                    chatSession.relationMeta.get 'requestor', (err, requestor) =>
                      requestor.should.eql @client.cookie 'session'
                      done()
