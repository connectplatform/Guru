should = require 'should'
{sample} = require 'ale'
logger = require 'torch'

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
      for field in ['mySession', 'myChats', 'visibleSessions'] #, 'visibleChatSessions', 'visibleChats']
        should.exist @collector.data[field], "Expected '#{field}' in the client side collections."
      done()

    it 'should show my chats', (done) ->

      sample @collector, 'data', 4, (err, events) =>

        @collector.data.visibleChats.length.should.eql 1
        @collector.data.visibleChatSessions.length.should.eql 1
        @collector.data.myChats.length.should.eql 1
        should.exist @collector.data.myChats[0].history
        done()

      Factory.create 'chatSession', {@sessionId}, (err) =>
        should.not.exist err

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

      #@collector.on 'data', (data, event) ->
        #logger.grey 'event:'.yellow, event

      # when myChat gets removed
      onRemove = (data, event) =>
        return unless event.operation is 'unset'
        @collector.off 'myChats.**', onRemove

        data.myChats.length.should.eql 0
        done()

      # when myChat gets added
      onAdd = (data, event) =>
        return unless event.operation is 'set'
        @collector.off 'myChats.**', onAdd

        data.myChats.length.should.eql 1

        # remove the chatSession
        @chatSession.remove (err) ->
          should.not.exist err

        # wait until the myChat gets deleted
        @collector.on 'myChats.**', onRemove


      @collector.on 'myChats.**', onAdd

      # create a chatSession (and a chat)
      Factory.create 'chatSession', {@sessionId}, (err, @chatSession) =>
        should.not.exist err

    it 'should not show my session in visibleSessions', ->

      # wait until we see a history record populate
      mySession = @collector.data.visibleSessions.find (s) -> s._id is @sessionId
      should.not.exist mySession, 'expected not to find myself in visibleSessions'

    it 'should show sessions for my account in visibleSessions', (done) ->

      Factory.create 'session', {@accountId}, (err, session) =>
        should.not.exist err
        should.exist session

        @collector.once 'visibleSessions.**', (data, event) =>
          {data: {accountId, _id, username, sessionSecret}} = event
          @accountId.should.eql accountId
          session._id.should.eql _id
          username.should.eql 'Example visitor'
          should.not.exist sessionSecret
          done()
