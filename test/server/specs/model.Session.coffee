should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Model - Session', ->
  beforeEach (done) ->
    console.log 'about to find Account'
    Account.findOne {}, (err, account) =>
      console.log 'found Account'
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        @userId = user._id
        done err

  it 'should let you create a Session for a Visitor', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      session.username.should.equal 'Example visitor'
      done()

  it 'should let you create a Session for a User', (done) ->
    data =
      accountId: @accountId
      userId: @userId
      username: 'Example User'
    Factory.create 'session', data, (err, session) =>
      should.not.exist err
      session.userId.toString().should.equal data.userId
      done()

  it 'should not let you create a Session without a username', (done) ->
    data =
      accountId: @accountId
      username: null
    Factory.create 'session', data, (err, session) =>
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path username with value `null`'
      err.errors.username.message.should.equal expectedErrMsg
      done()

  it 'should let you find an existing Session by its operator', (done) ->
    data = {@accountId, @userId}
    Factory.create 'session', data, (err, session) =>
      should.not.exist err
      should.exist session
      Session.sessionByOperator @userId, (err, foundSession) =>
        should.not.exist err
        should.exist foundSession
        foundSession._id.should.equal session._id
        done err

  it 'should not create every Session with the same secret', (done) ->
    data = {@accountId, @userId}
    Factory.create 'session', data, (err, session1) =>
      should.not.exist err
      should.exist session1
      session1Secret = session1.secret
      Factory.create 'session', data, (err, session2) =>
        should.not.exist err
        should.exist session2
        session1Secret.should.not.equal session2.secret
        done err