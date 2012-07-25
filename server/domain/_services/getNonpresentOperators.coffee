async = require 'async'
redgoose = require 'redgoose'
{ChatSession, Session} = redgoose.models

{getType} = require '../../../lib/util'

removeVisitors = (sessionId, cb) ->
  Session.get(sessionId).role.get (err, role) ->
    cb role isnt 'Visitor'

filterSessions = (sessionIds, chatId, cb) ->

  async.filter sessionIds, removeVisitors, (operatorList) ->

    ChatSession.getByChat chatId, (err, presentChatSessions) ->

      removePresentOperators = (sessionId, cb) ->
        sessionIds = presentChatSessions.map (chatSession) -> chatSession.sessionId

        currentIndex = sessionIds.indexOf sessionId
        result = null
        if currentIndex < 0
          #This operator is not in this chat
          cb null, sessionId
        else
          currentChatSession = presentChatSessions[currentIndex]
          #This operator is in this chat, but we only weed them out if they're a visible member
          currentChatSession.relationMeta.get 'type', (err, type) ->
            currentChatSession.relationMeta.get 'isWatching', (err, isWatching) ->
              if type is 'member' and isWatching is 'false'
                result = null
              else
                result = sessionId
              cb err, result

      async.map operatorList, removePresentOperators, (err, nonpresentList) ->
        cb err, nonpresentList.filter (element) -> element isnt null

packSessionData = (sessionId, cb) ->
  session = Session.get(sessionId)
  async.parallel {
    chatName: session.chatName.get
    role: session.role.get
  }, (err, sessionData) ->
    console.log "Error getting session data in getNonpresentOperators: #{err}" if err
    sessionData.id = sessionId
    cb sessionData

module.exports = (res, chatId) ->
  Session.allSessions.members (err, sessionIds) ->
    if err
      console.log "Error retrieving sessions in getNonpresentOperators: #{err}"
      return res.send err, null
    filterSessions sessionIds, chatId, (err, operatorIds) ->

      #We have the ids of everyone we want to display, now pack their session data
      async.map operatorIds, packSessionData, (operatorSessions) ->
        #async.map handles edge cases poorlyhandles edge cases poorly
        operatorSessions = [] if operatorSessions is undefined
        operatorSessions = [operatorSessions] unless getType(operatorSessions) is '[object Array]'
        res.send err, operatorSessions
