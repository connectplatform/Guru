should = require 'should'

db = config.require 'load/mongo'
{Session} = db.models

removeUnanswered = config.require 'services/operator/removeUnanswered'

boiler 'Service - removeUnanswered', ->
  beforeEach (done) ->
    @guru1Login (err, @guru1Client, @guru1Data) =>
      should.not.exist err
      should.exist @guru1Data
      should.exist @guru1Client
      
      @guru2Login (err, @guru2Client, @guru2Data) =>
        should.not.exist err
        should.exist @guru2Client
        should.exist @guru2Data
        
        done()

  it 'should remove a chat when it is there', (done) ->
    @newChat (err, {chatId, sessionId}) =>
      should.not.exist err
      should.exist chatId
      should.exist sessionId

      guru1SessionId = @guru1Data.sessionId
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
    guru1SessionId = @guru1Data.sessionId
    should.exist guru1SessionId

    Session.findById guru1SessionId, (err, guru1Session) =>
      should.not.exist err
      should.exist guru1Session
    
      guru1Session.unansweredChats.length.should.equal 0
      
      accountId = guru1Session.accountId
      removeUnanswered {accountId, @chatId}, (err) =>
        should.not.exist err
        done()
