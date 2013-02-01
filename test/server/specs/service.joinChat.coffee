should = require 'should'
stoic = require 'stoic'

boiler 'Service - Join Chat', ->

  it 'should emit "join" notification', (done) ->
    @getAuthed =>
      @newChat =>

        # listen for joinChat
        @channel = @getPulsar().channel @chatId
        @channel.once 'serverMessage', (data) ->
          data.type.should.eql 'notification'
          done()

        @client.joinChat {chatId: @chatId}, ->

  it 'should not join a non-existent chat', (done) ->
    @getAuthed =>
      @client.joinChat {chatId: 'abc1230123456789'}, (err, {status}) ->

        should.exist err, 'expected error'
        err.should.eql "chats/getRelationToChat requires 'chatId' to be a valid ChatId."
        done()

  describe 'after joining', ->
    beforeEach (done) ->
      @getAuthed (_..., {@accountId}) =>
        @newChat =>
          @client.joinChat {chatId: @chatId}, done

    it 'should associate an operator with a chat', (done) ->

      #TODO refactor this to check at a higher level than cache contents
      {ChatSession} = stoic.models
      ChatSession(@accountId).getBySession @sessionId, (err, data) =>
        should.not.exist err
        [chatSesson] = data
        chatSesson.chatId.should.eql @chatId
        done()

    it 'should notify operator of an unread message', (done) ->

      pulsar = @getPulsar()

      # set up session listener
      sessionNotifications = pulsar.channel "notify:session:#{@sessionId}"
      sessionNotifications.once 'unreadMessages', (counts) =>
        count = counts[@chatId]
        should.exist count
        count.should.eql 1
        done()

      sessionNotifications.ready =>

        # send a new message
        @client.say {message: 'hi', session: @visitorSession, chatId: @chatId}, =>
