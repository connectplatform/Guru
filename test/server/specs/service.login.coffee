should = require 'should'
stoic = require 'stoic'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @ownerLogin (err, client, accountId) =>
      should.not.exist err
      sessionId = client.cookie 'session'

      {Session} = stoic.models
      Session(accountId).get(sessionId).chatName.get (err, chatName) =>
        should.not.exist err
        chatName.should.eql "Owner Man"
        client.disconnect()
        done()

  it 'should not accept invalid email', (done) ->
    @invalidLogin (err, client, accountId) =>
      should.exist err
      err.should.eql 'Invalid user.'
      done()

  it 'should not accept invalid password', (done) ->
    @wrongpasswordLogin (err, client, accountId) =>
      should.exist err
      err.should.eql 'Invalid password.'
      done()

  it 'should reattatch you to an existing session', (done) ->
    @ownerLogin (err, client) =>
      sessionId = client.cookie 'session'

      client.setSessionOffline {sessionId: client.cookie('session')}, (err) =>
        should.not.exist err
        client.disconnect()

        @ownerLogin (err, client, accountId) =>
          should.not.exist err
          sessionId.should.eql client.cookie 'session'

          {Session} = stoic.models
          Session(accountId).get(sessionId).online.get (err, online) =>
            should.not.exist err
            online.should.eql true
            client.disconnect()
            done()
