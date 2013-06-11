# stoic = require 'stoic'
async = require 'async'

module.exports = (accountId, sessionId, next) ->
  {ChatSession} = stoic.models
  relationsByChat = {}
  lookUpRelation = (chatSession, cb) ->
    chatSession.relationMeta.get 'type', (err, type) ->
      relationsByChat[chatSession.chatId] = type
      cb err

  ChatSession(accountId).getBySession sessionId, (err, chatSessions) ->
    return next err, {} if err
    async.forEach chatSessions, lookUpRelation, (err) ->
      next err, relationsByChat
