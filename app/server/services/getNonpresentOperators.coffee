async = require 'async'
stoic = require 'stoic'
{ChatSession, Session} = stoic.models

{getType} = config.require 'load/util'

removeVisitors = (sessionId, cb) ->
  sessionId.role.get (err, role) ->
    config.log.warn 'Error getting role for session in getNonpresentOperators', {error: err, sessionId: sessionId} if err
    cb role isnt 'Visitor'

filterSessions = (sessions, chatId, done) ->

  async.filter sessions, removeVisitors, (operatorSessionList) ->

    ChatSession.getByChat chatId, (err, presentChatSessions) ->
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
          #This operator is in this chat, but we only weed them out if they're a visible member
          currentChatSession.relationMeta.getall (err, relationMeta) ->
            config.log.warn 'Error getting relationMeta for chatSession in getNonpresentOperators', {error: err, chatId: currentChatSession.chatId, sessionId: currentChatSession.sessionId} if err
            if relationMeta.type is 'member' and relationMeta.isWatching is 'false'
              result = null
            else
              result = session
            cb err, result

      async.map operatorSessionList, removePresentOperators, (err, nonpresentList) ->
        done err, nonpresentList.compact()

packSessionData = (session, cb) ->
  async.parallel {
    chatName: session.chatName.get
    role: session.role.get
  }, (err, sessionData) ->
    config.log.error 'Error getting session data in getNonpresentOperators', {error: err, sessionId: session.id} if err
    sessionData.id = session.id
    cb sessionData

module.exports = (res, chatId) ->
  Session.allSessions.members (err, sessionIds) ->
    if err
      config.log.error 'Error retrieving sessions for chat in getNonpresentOperators', {error: err, chatId: chatId}
      return res.reply err, null

    filterSessions sessionIds, chatId, (err, operatorSessions) ->

      # We have the sessions for everyone we want to display, now get their data
      async.map operatorSessions, packSessionData, (sessionData=[]) ->

        sessionData = [sessionData] unless getType(sessionData) is 'Array'
        res.reply err, sessionData
