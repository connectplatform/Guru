should = require 'should'
db = config.require 'server/load/mongo'
{Account, Session, User} = db.models


boiler 'Model - Session', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      done err

  beforeEach (done) ->
    User.findOne {}, (err, user) =>
      @userId = user._id
      done err

  it 'should let you create a Session for a Visitor', (done) ->
    data =
      accountId: @accountId
      userId: null
      chatSessions: []
      username: 'Example Visitor'

    Session.create data, (err, session) ->
      should.not.exist err
      session.username.should.equal data.username
      done()

  it 'should let you create a Session for a User', (done) ->
    data =
      accountId: @accountId
      userId: @userId
      chatSessions: []
      username: 'Example User'

    Session.create data, (err, session) =>
      should.not.exist err
      session.userId.toString().should.equal data.userId
      done()

# TODO: add tests to ensure Session.chatSessions only contains refs to acutal
# chatIds, no duplicates.