should = require 'should'
stoic = require 'stoic'

boiler 'Service - Join Chat', ->

  describe 'after joining', ->
    beforeEach (done) ->
      @getAuthed (_..., @accountId) =>
        @newChat =>
          @client.joinChat {chatId: @chatId}, done

    it 'should associate an operator with a chat', (done) ->

      session = @client.cookie('session')

      #TODO refactor this to check at a higher level than cache contents
      {ChatSession} = stoic.models
      ChatSession(@accountId).getBySession session, (err, [chatSesson]) =>
        should.not.exist err
        chatSesson.chatId.should.eql @chatId
        done()

    it 'should notify operator of an unread message', (done) ->

      pulsar = @getPulsar()
      session = @client.cookie('session')

      # set up session listener
      sessionNotifications = pulsar.channel "notify:session:#{session}"
      sessionNotifications.on 'unreadMessages', (counts) =>
        count = counts[@chatId]
        should.exist count
        count.should.eql 1
        done()

      sessionNotifications.ready =>

        # send a new message
        @client.say {message: 'hi', session: @visitorSession, chatId: @chatId}, =>
