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
      userId: @userId
      chatSessions: []
      username: 'Example Visitor'

    Session.create data, (err, session) ->
      should.not.exist err
      done()
