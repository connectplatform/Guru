should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, User, Website} = db.models
{chatStatusStates} = config.require 'load/enums'
querystring = require 'querystring'


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

  it 'should merge visitor data fields when getting visitorData', (done) ->
    queryStr = 'foo=bar&baz=qux&baz=quux&corge='
    queryData = querystring.parse queryStr
    acpData = {x: 2, y: 5, z: [1,2]}

    visitorData = {}
    visitorData.merge queryData
    visitorData.merge acpData
            
    data =
      queryData: queryData
      acpData: acpData
    Object.merge data, @validData

    Factory.create 'chat', data, (err, chat) =>
      should.not.exist err
      chat.visitorData.should.exist

      (Object.equal chat.visitorData, visitorData).should.be.true
      done()
      
  it 'should have an undefined visitorData when the determining fields are undefined', (done) ->
    Factory.create 'chat', @validData, (err, chat) =>
      should.not.exist err
      shouldBeEmpty = (o) -> (Object.equal {}, o).should.be.true
      shouldBeEmpty chat.acpData, 'acpData should not exist'
      shouldBeEmpty chat.queryData, 'queryData should not exist'
      shouldBeEmpty chat.visitorData, 'visitorData should not exist'

      done()      