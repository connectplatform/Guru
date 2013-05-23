should = require 'should'
db = config.require 'load/mongo'
{ObjectId} = db.Schema.Types
{ChatSession} = db.models

boiler 'Service - Join Chat', ->

  it 'should not join a non-existent chat', (done) ->
    @getAuthed =>
      notAChatId = @client.localStorage.sessionId
      @client.joinChat {chatId: notAChatId}, (err, {status}) ->
        should.exist err, 'expected error'
        errMsg = "chats/getRelationToChat requires 'chatId' to be a valid ChatId."
        err.should.equal errMsg
        done()

  describe 'after joining', ->
    beforeEach (done) ->
      @getAuthed (_..., {@accountId}) =>
        @newChat =>
          console.log {@chatId}
          @client.joinChat {chatId: @chatId}, (err, result) =>
            console.log {err, result}
            done err, result

    it 'should associate an operator with a chat', (done) ->
      console.log 'ABOUT TO BLOW UP'
      #TODO refactor this to check at a higher level than cache contents
      {ChatSession} = stoic.models
      ChatSession(@accountId).getBySession @sessionId, (err, data) =>
        should.not.exist err
        [chatSesson] = data
        chatSesson.chatId.should.eql @chatId
        done()

  #   it 'should notify operator of an unread message', (done) ->

  #     pulsar = @getPulsar()

  #     # set up session listener
  #     sessionNotifications = pulsar.channel "notify:session:#{@sessionId}"
  #     sessionNotifications.once 'unreadMessages', (counts) =>
  #       count = counts[@chatId]
  #       should.exist count
  #       count.should.eql 1
  #       done()

  #     sessionNotifications.ready =>

  #       # send a new message
  #       @client.say {message: 'hi', session: @visitorSession, chatId: @chatId}, =>
