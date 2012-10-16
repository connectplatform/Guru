async = require 'async'
stoic = require 'stoic'
{ChatSession, Session} = stoic.models

{getType} = config.require 'load/util'

removeVisitors = (session, cb) ->
  session.role.get (err, role) ->
    cb role isnt 'Visitor'

filterSessions = (sessions, chatId, done) ->

  async.filter sessions, removeVisitors, (operatorSessionList) ->

    ChatSession.getByChat chatId, (err, presentChatSessions) ->

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
          currentChatSession.relationMeta.get 'type', (err, type) ->
            currentChatSession.relationMeta.get 'isWatching', (err, isWatching) ->
              if type is 'member' and isWatching is 'false'
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
    console.log "Error getting session data in getNonpresentOperators: #{err}" if err
    sessionData.id = session.id
    cb sessionData

module.exports = (res, chatId) ->
  Session.allSessions.members (err, sessionIds) ->
    if err
      console.log "Error retrieving sessions in getNonpresentOperators: #{err}"
      return res.reply err, null

    filterSessions sessionIds, chatId, (err, operatorSessions) ->

      # We have the sessions for everyone we want to display, now get their data
      async.map operatorSessions, packSessionData, (sessionData=[]) ->

        sessionData = [sessionData] unless getType(sessionData) is 'Array'
        res.reply err, sessionData
