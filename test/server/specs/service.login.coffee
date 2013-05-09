should = require 'should'

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @ownerLogin (err, client, {sessionId, accountId}) =>
      should.not.exist err, err.stack if err

      {Session} = stoic.models
      Session(accountId).get(sessionId).chatName.get (err, chatName) =>
        chatName.should.eql "Owner Man"
        done()

  it 'should not accept invalid email', (done) ->
    @invalidLogin (err, client, {sessionId, accountId}) =>
      should.exist err
      err.should.eql 'Invalid user.'
      done()

  it 'should not accept invalid password', (done) ->
    @wrongpasswordLogin (err, client, {sessionId, accountId}) =>
      should.exist err
      err.should.eql 'Invalid password.'
      done()

  it 'should reattach you to an existing session', (done) ->
    @ownerLogin (err, client, {sessionId}) =>
      firstSessionId = sessionId

      client.setSessionOffline {sessionId: sessionId}, (err) =>
        should.not.exist err, err.stack if err

        @ownerLogin (err, client, {sessionId, accountId}) =>
          should.not.exist err
          firstSessionId.should.eql sessionId

          {Session} = stoic.models
          Session(accountId).get(sessionId).online.get (err, online) =>
            should.not.exist err
            online.should.eql true
            done()

  it 'Admin login should not crash the server', (done) ->
    @adminLogin (err, client, {sessionId, accountId}) =>
      should.exist err
      err.should.eql 'User not associated with accountId.'
      done()
