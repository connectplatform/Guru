async = require 'async'
db = config.require 'load/mongo'
{ChatSession, Session, User} = db.models

{getType} = config.require 'load/util'

removeVisitors = (session, cb) ->
  session.role.get (err, role) ->
    config.log.warn 'Error getting role for session in getNonpresentOperators', {error: err, sessionId: session.id} if err
    cb role isnt 'Visitor'

filterSessions = (accountId, sessions, chatId, done) ->

  async.filter sessions, removeVisitors, (operatorSessionList) ->

    ChatSession(accountId).getByChat chatId, (err, presentChatSessions) ->
      config.log.warn 'Error getting sessions for chat in getNonpresentOperators', {error: err, chatId: chatId} if err

      removePresentOperators = (session, cb) ->
        sessionIds = presentChatSessions.map (chatSession) -> chatSession.sessionId
        currentIndex = sessionIds.indexOf session.id
        result = null

        #This operator is not in this chat
        if currentIndex < 0
          cb null, session

        else
          currentChatSession = presentChatSessions[currentIndex]

          #TODO: use getVisibleOperators to do this

          #This operator is in this chat, but we only weed them out if they're a visible member
          currentChatSession.relationMeta.getall (err, relationMeta) ->
            if err
              meta = {error: err, chatId: currentChatSession.chatId, sessionId: currentChatSession.sessionId}
              config.log.warn 'Error getting relationMeta for chatSession in getNonpresentOperators', meta

            if relationMeta.type is 'member' and relationMeta.isWatching is 'false'
              result = null
            else
              result = session

            cb err, result

      async.map operatorSessionList, removePresentOperators, (err, nonpresentList) ->
        done err, nonpresentList.compact()

module.exports =
  required: ['chatId', 'sessionId', 'accountId']
  service: ({chatId, sessionId, accountId}, done) ->
    # First, find all ChatSession connecting some active Session to the Chat
    # denoted by chatId in which the connected 
    # 
    # 
    ChatSession.find {chatId, relation: 'Member'}, (err, chatSessions) ->
      done err, null if err

      console.log '<getNonpresentOperators>:', {chatSessions}
      
      sessionIdsToExclude = (cs.sessionId for cs in chatSessions)
      console.log '<getNonpresentOperators>:', {sessionIdsToExclude}

      Session.find {_id: {'$nin': sessionIdsToExclude}, accountId}, (err, sessions) ->
        console.log '<getNonpresentOperators>:', {sessions}
        operatorSessions = sessions.filter (s) -> (s.userId?)
        console.log '<getNonpresentOperators>:', {operatorSessions}
        done err, {operators: operatorSessions}

    # Session(accountId).allSessions.members (err, sessions) ->
    #   if err
    #     config.log.error 'Error retrieving sessions for chat in getNonpresentOperators', {error: err, chatId: chatId}
    #     return done err

    #   filterSessions accountId, sessions, chatId, (err, operatorSessions) ->

    #     # We have the sessions for everyone we want to display, now get their data
    #     async.map operatorSessions, packSessionData, (sessionData=[]) ->

    #       sessionData = [sessionData] unless getType(sessionData) is 'Array'
    #       done err, {operators: sessionData}
