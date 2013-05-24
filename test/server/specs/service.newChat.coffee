should = require 'should'
particle = require 'particle'
db = config.require 'load/mongo'
{Chat, ChatSession} = db.models

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

        # Local bin to catch updates for testing
        @collectedData = []
        # Which is listening for data events
        collector.on 'data', (data, event) =>
          @collectedData.push data
        
        # And is registered with a Stream
        collector.register (err) =>
          should.not.exist err
          message = 'Hello!'
          visitor.say {message, @chatId}, (err) =>
            should.not.exist err
            @collectedData.should.not.be.empty
            {history} = @collectedData[0].chats[0]
            history[0].message.should.equal message
            done()
          
  # it 'should notify operators of a new chat', (done) ->
  #   @getAuthed =>
  #     should.exist @sessionSecret
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

  it 'should create a chatSession', (done) ->
    @getAuthed =>
      @newChat =>
        ChatSession.findOne {@chatId}, (err, chatSession) ->
          should.not.exist err
          should.exist chatSession
          done()
