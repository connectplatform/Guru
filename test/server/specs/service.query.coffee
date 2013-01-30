should = require 'should'

boiler 'Service - Query', ->
  beforeEach ->

    # Make a chat
    @sessions = []
    @visibleSessions = []

    @prep = (next) =>

      # Given an operator is logged in
      @guru1Login (err, @guru1Client, {@accountId, sessionId}) =>
        @guru1Session = sessionId

        # And a visitor creates a chat
        @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor, data) =>
          @sessions.push @visitorSession
          @visibleSessions.push @visitorSession

          # And the operator accepts the chat
          @guru1Client.acceptChat {chatId: @chatId}, =>
            @sessions.push @guru1Session
            @visibleSessions.push @guru1Session

            # And another operator logs in
            @guru2Login (err, @guru2Client, {sessionId}) =>
              @guru2Client.watchChat {chatId: @chatId}, =>
                @sessions.push sessionId

                # Provide the tests a way to access the chat
                stoic = require 'stoic'
                {ChatSession} = stoic.models
                @chatSessionHandle = ChatSession(@accountId)

                next()

  it 'should let you get all the sessions for a chat', (done) ->
    @prep =>
      query = config.require 'services/queries/query'
      query {
        accountId: @accountId
        queries:
          queriedSessions:
            ids: chatId: @chatId
            select: sessionId: 'chatSession.sessionId'
      }, (err, {queriedSessions}) =>
        should.not.exist err

        queriedSessions.length.should.eql 3

        for session in @sessions
          queriedSessions.should.includeEql sessionId: session
        done()

  it 'should let you get all the visible sessions for a chat', (done) ->
    @prep =>
      query = config.require 'services/queries/query'
      query {
        accountId: @accountId
        queries:
          queriedSessions:
            ids: chatId: @chatId
            select: sessionId: 'chatSession.sessionId'
            where: 'chatSession.relationMeta.isWatching': 'false'
      }, (err, {queriedSessions}) =>
        should.not.exist err

        queriedSessions.length.should.eql 2

        for session in @visibleSessions
          queriedSessions.should.includeEql sessionId: session
        done()

  it 'should let you get all the visible staff for a chat', (done) ->
    @prep =>
      query = config.require 'services/queries/query'
      query {
        accountId: @accountId
        queries:
          queriedSessions:
            ids: chatId: @chatId
            select: sessionId: 'chatSession.sessionId'
            where:
              'chatSession.relationMeta.isWatching': 'false'
              'session.role': '!Visitor'
      }, (err, {queriedSessions}) =>
        should.not.exist err

        queriedSessions.length.should.eql 1

        done()

  it 'should let you query for individual models', (done) ->
    @prep =>
      @visitor.say {chatId: @chatId, message: 'wheee'}, =>
        query = config.require 'services/queries/query'
        query {
          accountId: @accountId
          queries:
            aChat:
              ids: chatId: @chatId
              select: history: 'chat.history'
        }, (err, {aChat:[chat]}) =>
          should.not.exist err
          history = chat.history
          history[0].message.should.eql 'wheee'
          done()

  it 'should let you get the visitor for a chat', (done) ->
    @prep =>
      query = config.require 'services/queries/query'
      query {
        accountId: @accountId
        queries:
          visitors:
            ids: chatId: @chatId
            select: sessionId: 'chatSession.sessionId'
            where:
              'session.role': 'Visitor'
      }, (err, {visitors}) =>
        should.not.exist err

        visitors.length.should.eql 1

        done()

  describe 'with invalid params', ->

    it 'should display an error and return no results', (done) ->
      @prep =>
        query = config.require 'services/queries/query'
        query {
          accountId: @accountId
          queries:
            visitors:
              select:
                sessionId: 'chatSession.sessionId'
              where:
                'session.role': 'Visitor'
        }, (err, {visitors}) =>
          should.not.exist err
          visitors.length.should.eql 0

          done()
