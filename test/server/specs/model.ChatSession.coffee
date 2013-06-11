should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, ChatSession, Session, User, Website} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - ChatSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.not.exist err
        @userId = user._id
        Website.findOne {accountId: @accountId}, (err, website) =>
          should.not.exist err
          should.exist website
          @websiteId = website._id
          @websiteUrl = website.url
          chatData =
            accountId: @accountId
            websiteId: @websiteId
            websiteUrl: @websiteUrl
            name: 'Visitor'
          Factory.create 'chat', chatData, (err, chat) =>
            should.not.exist err
            @chatId = chat._id
            sessionData =
              accountId: @accountId
            Factory.create 'session', sessionData, (err, session) =>
              should.not.exist err
              @sessionId = session._id
              done err

  it 'should let you create a valid ChatSession', (done) ->
    Factory.create 'chatSession', {@sessionId, @chatId}, (err, chatSession) =>
      should.not.exist err
      should.exist chatSession
      chatSession.sessionId.toString().should.equal @sessionId
      chatSession.chatId.toString().should.equal @chatId
      chatSession.relation.should.equal 'Member'
      done()

  it 'should not let you create a ChatSession without all data', (done) ->
    data =
      relation: null
      sessionId: @sessionId
      chatId: @chatId

    Factory.create 'chatSession', data, (err, chatSession) =>
      should.exist err
      expectedErrMsg = 'Validator "enum" failed for path relation with value `null`'
      err.errors.relation.message.should.equal expectedErrMsg
      done()
