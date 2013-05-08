should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Model - Session', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        @userId = user._id
        Factory.define 'validSession', 'session', {
          accountId: @accountId
        }
        done err

  it 'should let you create a Session for a Visitor', (done) ->
    Factory.create 'validSession', (err, session) =>
      should.not.exist err
      session.username.should.equal 'Example visitor'
      done()

  it 'should let you create a Session for a User', (done) ->
    data =
      userId: @userId
      username: 'Example User'
    Factory.create 'validSession', data, (err, session) =>
      should.not.exist err
      session.userId.toString().should.equal data.userId
      done()

  it 'should not let you create a Session without a username', (done) ->
    data =
      username: null
    Factory.create 'validSession', data, (err, session) =>
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path username'
      err.errors.username.message.should.equal expectedErrMsg
      done()