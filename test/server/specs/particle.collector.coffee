should = require 'should'
logger = config.require 'lib/logger'
{Chat} = config.require('server/load/mongo').models
{Collector} = require 'particle'

boiler 'Particle', ->

  describe 'with a registered collector', ->

    beforeEach (done) ->
      Factory.create 'session', {@accountId}, (err, session) =>
        should.not.exist err
        should.exist session
        @sessionId = session._id

        @collector = new Collector
          #onDebug: logger.grey
          network:
            host: 'localhost'
            port: process.env.GURU_PORT
          identity:
            sessionSecret: session.secret

        @collector.register (err) ->
          should.not.exist err

        @collector.ready done

    #afterEach ->
      #@collector.disconnect()

    it 'should have all collections', (done) ->
      for field in ['mySession', 'myChats'] #, 'chatSessions', 'visibleSessions', 'visibleChats']
        should.exist @collector.data[field], "Expected '#{field}' in the client side collections."
      done()

    it 'should show my chats', (done) ->
      Factory.create 'chatSession', {@sessionId}, (err) =>
        should.not.exist err

      @collector.once 'data', (event) =>
        @collector.data.myChats.length.should.eql 1
        done()

    it 'should show chat updates', (done) ->

      # wait until we see a history record populate
      listener = (event) =>
        chats = @collector.data.myChats
        history = @collector.data.myChats?[0]?.history
        if history? and history.length > 0
          @collector.off 'data', listener
          done()

      @collector.on 'data', listener

      # create a chatSession (and a chat)
      Factory.create 'chatSession', {@sessionId}, (err, chatSession) =>
        should.not.exist err

        # update our chat to add history
        {chatId} = chatSession
        Chat.findById chatId, (err, chat) ->
          should.not.exist err
          should.exist chat

          chat.history.push {
            timestamp: new Date
            message: 'hello'
            username: 'Bob'
          }
          chat.save()

    it 'should delete a chat when the relationship is disconnected', (done) ->

      # wait until the chat gets deleted
      waitForDelete = (data, event) =>
        if @collector.data.myChats.length is 0
          done()

      # wait until we have a chat
      waitForChat = (data, event) =>
        if @collector.data.myChats.length > 0
          @collector.off 'data', waitForChat
          @collector.on 'data', waitForDelete

      @collector.on 'data', waitForChat

      # create a chatSession (and a chat)
      Factory.create 'chatSession', {@sessionId}, (err, chatSession) =>
        should.not.exist err

        # update our chat to add history
        chatSession.remove (err) ->
          should.not.exist err
