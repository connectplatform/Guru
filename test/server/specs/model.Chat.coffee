should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, User} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - Chat', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      done err

  beforeEach (done) ->
    User.findOne {}, (err, user) =>
      @userId = user._id
      done err

  it 'should let you create a Chat with a valid status', (done) ->
    data =
      accountId: @accountId
      status: chatStatusStates[0]
      history: []

    Chat.create data, (err, chat) ->
      should.not.exist err
      chat.accountId.toString().should.equal data.accountId
      chat.history.should.be.empty and data.history.should.be.empty
      done()

  it 'should not let you create a Chat with an invalid status', (done) ->
    data =
      accountId: @accountId
      status: 'notAStatus'
      history: []

    Chat.create data, (err, chat) ->
      should.exist err
      expectedErrMsg = 'Validator "enum" failed for path status'
      err.errors.status.message.should.equal expectedErrMsg
      done()

  it 'should not save a chat with an incomplete history element', (done) ->
    data =
      accountId: @accountId
      status: chatStatusStates[0]
      history: [
        message: 'I need a timestamp.'
        username: 'Example User'
      ]

    Chat.create data, (err, chat) ->
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path timestamp'
      err.errors['history.0.timestamp'].message.should.equal expectedErrMsg
      done()

  it 'should save a chat without a User in the history', (done) ->
    data =
      accountId: @accountId
      status: chatStatusStates[0]
      history: [
        message: 'I am a visitor.'
        username: 'Example visitor'
        timestamp: Date.now()
      ]

    Chat.create data, (err, chat) ->
      should.not.exist err
      chat.history[0].timestamp.should.equal data.history[0].timestamp
      done()

  it 'should save a chat with a User in the history', (done) ->
    data =
      accountId: @accountId
      status: chatStatusStates[0]
      history: [
        message: 'I am a User.'
        username: 'Example User'
        timestamp: Date.now()
        userId: @userId
      ]

    Chat.create data, (err, chat) ->
      should.not.exist err
      chat.history[0].timestamp.should.equal data.history[0].timestamp
      chat.history[0].userId.toString().should.equal data.history[0].userId
      done()

