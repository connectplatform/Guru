should = require 'should'

boiler 'Service - Query', ->
  beforeEach ->

    # Make a chat
    @sessions = []
    @visibleSessions = []

    @prep = (next) =>
      @guru1Login (err, @guru1Client, @accountId) =>

        @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, @visitor, data) =>
          @sessions.push @visitor.cookie 'session'
          @visibleSessions.push @visitor.cookie 'session'

          # Add some operators
          @guru1Client.acceptChat {chatId: @chatId}, =>
            @sessions.push @guru1Client.cookie 'session'
            @visibleSessions.push @guru1Client.cookie 'session'

            @guru2Login (err, @guru2Client) =>
              @guru2Client.watchChat {chatId: @chatId}, =>
                @sessions.push @guru2Client.cookie 'session'

                # Provide the tests a way to access the chat
                stoic = require 'stoic'
                {ChatSession} = stoic.models
                @chatSessionHandle = ChatSession(accountId)

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

  it 'should let you get all the visible staff for a chat', (done) ->
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
