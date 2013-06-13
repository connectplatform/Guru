should = require 'should'
db = config.require 'load/mongo'
{Session} = db.models

boiler 'Service - Login', ->

  it 'should log you in', (done) ->
    @ownerLogin (err, client, {sessionSecret, accountId}) =>
      should.not.exist err, err.stack if err
      Session.findOne {secret: sessionSecret}, (err, session) =>
        should.not.exist err
        should.exist session
        session.secret.should.equal sessionSecret
        done()

  it 'should not accept invalid email', (done) ->
    @invalidLogin (err, client, {sessionSecret, accountId}) =>
      should.exist err
      err.should.equal 'Invalid user.'
      done()

  it 'should not accept invalid password', (done) ->
    @wrongpasswordLogin (err, client, {sessionSecret, accountId}) =>
      should.exist err
      err.should.equal 'Invalid password.'
      done()

  it 'should reattach you to an existing session', (done) ->
    @ownerLogin (err, client, {sessionSecret}) =>
      Session.findOne {secret: sessionSecret}, (err, session) =>
        should.not.exist err
        should.exist session

        firstSessionId = session._id
        firstSessionSecret = sessionSecret
        client.setSessionOffline {sessionId: firstSessionId}, (err) =>
          should.not.exist err, err.stack if err

          @ownerLogin (err, client, {sessionSecret, accountId}) =>
            should.not.exist err
            firstSessionSecret.should.equal sessionSecret

            Session.findOne {secret: sessionSecret}, (err, session) =>
              should.not.exist err
              should.exist session

              session.online.should.equal true
              done()

  it 'Admin login should not crash the server', (done) ->
    @adminLogin (err, client, {sessionSecret, accountId}) =>
      should.exist err
      err.should.equal 'User not associated with accountId.'
      done()
