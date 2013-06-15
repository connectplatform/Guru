should = require 'should'
db = config.require 'load/mongo'
{ObjectId} = db.Schema.Types
{ChatSession, Session} = db.models
{getString} = config.require 'load/util'

boiler 'Service - Join Chat', ->

  it 'should not join a non-existent chat', (done) ->
    @getAuthed (err, client, vars) =>
      notAChatId = vars.sessionId
      @client.joinChat {chatId: notAChatId}, (err, {status}) ->
        should.exist err, 'expected error'
        errMsg = "chats/getRelationToChat requires 'chatId' to be a valid ChatId."
        err.should.equal errMsg
        done()

  describe 'after joining', ->
    beforeEach (done) ->
      @getAuthed (_..., vars) =>
        @newChat =>
          @client.joinChat {@chatId}, (err, result) =>
            @sessionId = vars.sessionId
            should.exist @sessionId
            done err, result

    it 'should associate an operator with a chat', (done) ->
      ChatSession.findOne {@sessionId}, (err, chatSession) =>
        should.not.exist err
        should.exist chatSession
        chatSession.chatId.should.equal @chatId
        done()

    it 'should notify operator of an unread message', (done) ->
      Session.findById @sessionId, (err, session) =>
        should.not.exist err
        should.exist session
        session.unreadMessages.should.equal 0

        data =
          message: 'Hello'
          sessionId: @sessionId
          chatId: @chatId
        @client.say data, (err) =>
          should.not.exist err
          Session.findById @sessionId, (err, updatedSession) =>
            should.not.exist err
            should.exist updatedSession
            updatedSession.unreadMessages.should.equal 1
            done()
