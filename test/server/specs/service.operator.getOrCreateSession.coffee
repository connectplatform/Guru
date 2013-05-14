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
    @getOrCreateSession @user, (err, sessionSecret) =>
      should.not.exist err
      should.exist sessionSecret
      done()

  it 'should get an existing Session when one already exists', (done) ->
    Factory.create 'session', {@accountId}, (err, session) =>
      should.not.exist err
      should.exist session
      prevSessionSecret = session.secret
      @getOrCreateSession @user, (err, {sessionSecret}) =>
        should.not.exist err
        should.exist sessionSecret
        sessionSecret.should.equal prevSessionSecret
        done()
