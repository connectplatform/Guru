should = require 'should'

db = config.require 'load/mongo'
{Session} = db.models

removeUnanswered = config.require 'services/operator/removeUnanswered'

boiler 'Service - removeUnanswered', ->
  beforeEach (done) ->
    @guru1Login (err, @guru1Client) =>
      should.not.exist err
      should.exist @guru1Client
      
      @guru2Login (err, @guru2Client) =>
        should.not.exist err
        should.exist @guru2Client
        done()

  it 'should remove a chat when it is there', (done) ->
    @newChat =>
      guru1SessionId = @guru1Client.localStorage.sessionId
      should.exist guru1SessionId

      Session.findById guru1SessionId, (err, guru1Session) =>
        should.not.exist err
        should.exist guru1Session
      
        guru1Session.unansweredChats.length.should.equal 1
      
        accountId = guru1Session.accountId
        removeUnanswered {accountId, @chatId}, (err) =>
          Session.findById guru1SessionId, (err, guru1Session) =>
            should.not.exist err
            should.exist guru1Session
            guru1Session.unansweredChats.length.should.equal 0
            done()
    

  it 'should not blow up when a chat is not there', (done) ->
    guru1SessionId = @guru1Client.localStorage.sessionId
    should.exist guru1SessionId

    Session.findById guru1SessionId, (err, guru1Session) =>
      should.not.exist err
      should.exist guru1Session
    
      guru1Session.unansweredChats.length.should.equal 0
      
      accountId = guru1Session.accountId
      removeUnanswered {accountId, @chatId}, (err) =>
        should.not.exist err
        done()
