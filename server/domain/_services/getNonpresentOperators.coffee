async = require 'async'
redgoose = require 'redgoose'
{ChatSession, Session} = redgoose.models

{getType} = require '../../../lib/util'

removeVisitors = (sessionId, cb) ->
  Session.get(sessionId).role.get (err, role) ->
    cb role isnt 'Visitor'

filterSessions = (sessionIds, chatId, cb) ->

  async.filter sessionIds, removeVisitors, (operatorList) ->

    ChatSession.getByChat chatId, (err, chatSessions) ->
      presentSessionIds = chatSession.sessionId for chatSession in chatSessions

      removePresentOperators = (sessionId, cb) ->
        for presentSessionId in presentSessionIds
          return cb err, null if presentSessionId is sessionId
        cb err, sessionId

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
        operatorSessions = [operatorSessions] unless getType(operatorSessions) is '[object Array]'
        res.send err, operatorSessions
