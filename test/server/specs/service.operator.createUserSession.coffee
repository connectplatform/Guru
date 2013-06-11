should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Service - createUserSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.exist user
        @user = user
        @userId = user._id
        @createUserSession = config.service 'operator/createUserSession'
        done err

  it 'should create a User Session given an existing User', (done) ->
    @createUserSession @user, (err, session) =>
      should.not.exist err
      should.exist session
      done()

  it 'should not create a User Session without an existing User', (done) ->
    @createUserSession null, (err, session) =>
      should.exist err
      expectedErr = "Error: operator/createUserSession requires 'accountId' to be defined."
      err.toString().should.equal expectedErr
      done()
