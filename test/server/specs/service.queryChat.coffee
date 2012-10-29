should = require 'should'

boiler 'Service - Query Chat', ->
  beforeEach (done) ->
    # Make a chat
    @sessions = []
    @visibleSessions = []
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

              done()

  it 'should let you get all the sessions for a chat', (done) ->
    queryChat = config.require 'services/chats/queryChat'
    queryChat {
      accountId: @accountId
      chatId: @chatId
      queries:
        queriedSessions:
          select: ['sessionId']
    }, (err, {queriedSessions}) =>
      should.not.exist err

      queriedSessions.length.should.eql 3

      for session in @sessions
        queriedSessions.should.includeEql sessionId: session
      done()

  it 'should let you get all the visible sessions for a chat', (done) ->
    queryChat = config.require 'services/chats/queryChat'
    queryChat {
      accountId: @accountId
      chatId: @chatId
      queries:
        queriedSessions:
          select: ['sessionId']
          where: isWatching: 'false'
    }, (err, {queriedSessions}) =>
      should.not.exist err

      queriedSessions.length.should.eql 2

      for session in @visibleSessions
        queriedSessions.should.includeEql sessionId: session
      done()

  it 'should let you get all the visible staff for a chat', (done) ->
    queryChat = config.require 'services/chats/queryChat'
    queryChat {
      accountId: @accountId
      chatId: @chatId
      queries:
        queriedSessions:
          select: ['sessionId']
          where:
            isWatching: 'false'
            role: '!Visitor'
    }, (err, {queriedSessions}) =>
      should.not.exist err

      queriedSessions.length.should.eql 1

      done()
