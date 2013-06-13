should = require 'should'
particle = require 'particle'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models
logger = config.require 'lib/logger'

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

  it 'should create a new Chat with visitor data', (done) ->
    @getAuthed =>
      formData =
          k1: 'v1'
          k2: 'v2'
      queryData =
          k3: 'v3'
          k4: 'v4'
      visitorData =
        username: 'visitor'
        websiteUrl: 'foo.com'
        formData: formData
        queryData: queryData

      @newVisitor visitorData, (err, visitor) =>
        {@sessionId, @sessionSecret, @chatId} = visitor.localStorage
        Chat.findById @chatId, (err, chat) =>
          should.not.exist err
          should.exist chat
          chat._id.should.equal @chatId

          (Object.equal chat.formData, formData).should.be.true
          (Object.equal chat.queryData, queryData).should.be.true

          allVisitorData = {}
          allVisitorData.merge formData
          allVisitorData.merge queryData
          (Object.equal allVisitorData, chat.visitorData).should.be.true

          done()

  it 'should let you chat', (done) ->

    # Given I am logged in and I have a message to send
    message = 'Hello!'
    @getAuthed =>

      # And I have a chat
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, visitor) =>

        # And I have a Collector
        collector = new particle.Collector
          network:
            host: 'localhost'
            port: process.env.GURU_PORT
          identity:
            sessionSecret: @sessionSecret

        # Which is listening to chat history
        collector.once 'myChats.history', (data, event) =>

          # Then I should receive a message
          event.data.should.not.be.empty
          should.exist event.data[0].message
          event.data[0].message.should.equal message
          done()

        # When I register the collector
        collector.register (err) =>
          should.not.exist err

          # And I send a message
          visitor.say {message, @chatId}, (err) =>
            should.not.exist err

  it 'should notify operators of a new chat', (done) ->
    @getAuthed =>
      Session.findOne {secret: @sessionSecret}, (err, session) =>
        should.not.exist err
        should.exist session
        {unansweredChats} = session
        unansweredChats.should.be.empty
        @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, visitor) =>
          Session.findOne {secret: @sessionSecret}, (err, updatedSess) =>
            should.not.exist err
            should.exist updatedSess
            updatedUnansweredChats = updatedSess.unansweredChats
            updatedUnansweredChats.should.not.be.empty
            updatedUnansweredChats.should.include @chatId
            done()

  it 'should return {noOperators: true} if no operators are available', (done) ->
    @getAuthedWith {email: 'guru3@foo.com', password: 'foobar'}, =>
      @newChatWith {username: 'visitor', websiteUrl: 'bar.com'}, (err, {noOperators}) ->
        should.not.exist err
        should.exist noOperators
        noOperators.should.eql true
        done()

  it 'should create a chatSession', (done) ->
    @getAuthed =>
      @newChat =>
        ChatSession.findOne {@chatId}, (err, chatSession) ->
          should.not.exist err
          should.exist chatSession
          done()
