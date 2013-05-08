should = require 'should'
db = config.require 'server/load/mongo'
{Account, Chat, ChatSession, Session, User} = db.models
{chatStatusStates} = config.require 'load/enums'


boiler 'Model - ChatSession', ->
  beforeEach (done) ->
    Account.findOne {}, (err, account) =>
      @accountId = account._id
      done err

  beforeEach (done) ->
    User.findOne {}, (err, user) =>
      @userId = user._id
      done err

  beforeEach (done) ->
    data =
      accountId: @accountId
      status: chatStatusStates[0]
      history: []
    Chat.create data, (err, chat) =>
      @chatId = chat._id
      done err

  beforeEach (done) ->
    data =
      accountId: @accountId
      userId: null
      chatSession: []
      username: 'Example Visitor'
    Session.create data, (err, session) =>
      @sessionId = session._id
      done err

  it 'should let you create a ChatSession', (done) ->
    data =
      accountId: @accountId
      sessionId: @sessionId
      chatId: @chatId
      creationDate: Date.now()
      isWatching: false
      relation: 'Member'

    ChatSession.create data, (err, chatSession) ->
      should.not.exist err
      chatSession.accountId.toString().should.equal data.accountId
      chatSession.sessionId.toString().should.equal data.sessionId
      chatSession.chatId.toString().should.equal data.chatId
      done()
