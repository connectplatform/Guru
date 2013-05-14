should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Service - getOrCreateSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.exist user
        @user = user
        @userId = user._id
        @getOrCreateSession = config.service 'operator/getOrCreateSession'
        done err

  it 'should create a new Session when one does not exist', (done) ->
    @getOrCreateSession @user, (err, sessionKey) =>
      should.not.exist err
      should.exist sessionKey
      done()

  it 'should get an existing Session when one already exists', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session
      prevSessionKey = session.key
      @getOrCreateSession @user, (err, {sessionKey}) =>
        should.not.exist err
        should.exist sessionKey
        sessionKey.should.equal prevSessionKey
        done()
