should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, User, Website} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - Chat', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        @userId = user._id
        Website.findOne {accountId: @accountId}, (err, website) =>
          should.not.exist err
          should.exist website
          @websiteId = website._id
          @websiteUrl = website.url
          @chatName = 'MyChat'
          @validData = {@accountId, @websiteId, @websiteUrl, name: @chatName}
          done err

  it 'should let you create a valid Chat with empty history', (done) ->
    Factory.create 'chat', @validData, (err, chat) =>
      should.not.exist err
      chat.accountId.toString().should.equal @accountId
      chat.history.should.be.empty
      done()

  it 'should save a chat without a User in the history', (done) ->
    data =
      history: [
        message: 'I am a visitor.'
        username: 'Example visitor'
        timestamp: Date.now()
      ]
    Object.merge data, @validData

    Factory.create 'chat', data, (err, chat) =>
      should.not.exist err
      chat.history[0].timestamp.valueOf().should.equal data.history[0].timestamp
      done()

  it 'should save a chat with a User in the history', (done) ->
    data =
      history: [
        message: 'I am a User.'
        username: 'Example User'
        timestamp: Date.now()
        userId: @userId
      ]
    Object.merge data, @validData

    Factory.create 'chat', data, (err, chat) =>
      should.not.exist err
      chat.history[0].timestamp.valueOf().should.equal data.history[0].timestamp
      chat.history[0].userId.toString().should.equal data.history[0].userId
      done()

  it 'should not let you create a Chat with an invalid status', (done) ->
    data =
      status: 'notAStatus'
    Object.merge data, @validData
    
    Factory.create 'chat', data, (err, chat) =>
      should.exist err
      expectedErrMsg = 'Validator "enum" failed for path status with value `notAStatus`'
      err.errors.status.message.should.equal expectedErrMsg
      done()

  it 'should not let you create a Chat without a websiteId', (done) ->
    data = {}
    Object.merge data, @validData
    data.websiteId = null

    Factory.create 'chat', data, (err, chat) =>
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path websiteId with value `null`'
      err.errors.websiteId.message.should.equal expectedErrMsg
      done()

  it 'should not save a chat with an incomplete history element', (done) ->
    data =
      history: [
        message: 'I need a timestamp.'
        username: 'Example User'
      ]
    Object.merge data, @validData

    Factory.create 'chat', data, (err, chat) =>
      should.exist err
      expectedErrMsg = 'Validator "required" failed for path timestamp with value `undefined`'
      err.errors['history.0.timestamp'].message.should.equal expectedErrMsg
      done()

