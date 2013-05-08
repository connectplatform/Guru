should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, ChatSession, Session, User} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - ChatSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      User.findOne {accountId: @accountId}, (err, user) =>
        should.not.exist err
        @userId = user._id
        Factory.create 'chat', (err, chat) =>
          should.not.exist err
          @chatId = chat._id
          Factory.create 'session', (err, session) =>
            should.not.exist err
            @sessionId = session._id
            done err

  it 'should let you create a ChatSession', (done) ->
    data =
      sessionId: @sessionId
      chatId: @chatId
      relation: 'Member'
    Factory.create 'chatSession', data, (err, chatSession) =>
      should.not.exist err
      should.exist chatSession
      chatSession.sessionId.toString().should.equal data.sessionId
      chatSession.chatId.toString().should.equal data.chatId
      chatSession.relation.should.equal data.relation
      done()

  it 'should not let you create a ChatSession without all data', (done) ->
    data =
      sessionId: @sessionId
      chatId: @chatId
      relation: null

    Factory.create 'chatSession', data, (err, chatSession) =>
      should.exist err
      expectedErrMsg = 'Validator "enum" failed for path relation'
      err.errors.relation.message.should.equal expectedErrMsg
      done()
