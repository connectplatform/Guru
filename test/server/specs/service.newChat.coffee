should = require 'should'
particle = require 'particle'
db = config.require 'load/mongo'
{Chat} = db.models

boiler 'Service - New Chat', ->

  it 'should create a new Chat', (done) ->
    @getAuthed =>
      visitorData =
        username: 'visitor'
        websiteUrl: 'foo.com'
      @newVisitor visitorData, (err, visitor) =>
        {@sessionId, @sessionSecret, @chatId} = visitor.localStorage
        Chat.findById @chatId, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat._id.should.equal @chatId
          done()

  it 'should let you chat', (done) ->
    # Given I am logged in
    @getAuthed =>
      # And I have a chat
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, visitor) =>
        # console.log '@sessionSecret', @sessionSecret

        # And I have a Collector
        collector = new particle.Collector
          network:
            host: 'localhost'
            port: process.env.GURU_PORT
          identity:
            sessionSecret: @sessionSecret

        @collectedData = []
        # Which is listening for data events
        collector.on 'data', (data, event) ->
          @collectedData.push data
          console.log {data, event}
        
        # And is registered with a Stream
        collector.register (err) ->
          should.not.exist err
          done()

        # STOP: TESTING `SAY`
          
        # # And I am listening on the channel
        # @channel = @getPulsar().channel @chatId
        # @channel.on 'serverMessage', (data) ->
        #   if data.username is 'visitor'

        #     # Then I should see my message
        #     data.message.should.eql 'hello!'
        #     done()

        # # When I send a message
        # visitor.say {message: 'hello!', chatId: @chatId}, (err) =>
        #   should.not.exist err

  # it 'should notify operators of a new chat', (done) ->
  #   @getAuthed =>
  #     should.exist @sessionId
  #     notify = @getPulsar().channel "notify:session:#{@sessionId}"
  #     notify.once 'unansweredChats', ({count}) =>
  #       count.should.eql 1
  #       done()

  #     @newChat ->

  # it 'should return {noOperators: true} if no operators are available', (done) ->
  #   @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
  #     @newChatWith {username: 'visitor', websiteUrl: 'bar.com'}, (err, {noOperators}) ->
  #       should.not.exist err
  #       should.exist noOperators
  #       noOperators.should.eql true
  #       done()

  # it 'should create a chatsession', (done) ->
  #   {ChatSession} = require('stoic').models
  #   @getAuthed =>
  #     @newChat =>
  #       ChatSession(@account._id).getByChat @chatId, (err, chatSession) ->
  #         should.not.exist err
  #         should.exist chatSession
  #         done()
