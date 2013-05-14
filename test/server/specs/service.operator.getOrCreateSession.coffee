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
    @getOrCreateSession @user, (err, session) =>
      should.not.exist err
      should.exist session
      done()

  it 'should get an existing Session when one already exists', (done) ->
    Factory.create 'session', {@accountId}, (err, prevSession) =>
      should.not.exist err
      should.exist prevSession
      @getOrCreateSession @user, (err, res) =>
        should.not.exist err
        should.exist res
        should.exist res.sessionId
        res.sessionId.should.equal prevSession._id
        done()
