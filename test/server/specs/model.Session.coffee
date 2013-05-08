should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Model - Session', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        @userId = user._id
        done err

  it 'should let you create a Session for a Visitor', (done) ->
    data =
      accountId: @accountId
      userId: null
      username: 'Example Visitor'

    Factory.create 'session', data, (err, session) =>
      should.not.exist err
      session.username.should.equal data.username
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
      userId: null
      username: null

    Factory.create 'session', data, (err, session) =>
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path username'
      err.errors.username.message.should.equal expectedErrMsg
      done()