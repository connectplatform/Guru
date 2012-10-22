stoic = require 'stoic'
async = require 'async'

module.exports = (sessionId, next) ->
  {Session, ChatSession} = stoic.models
  relationsByChat = {}
  lookUpRelation = (chatSession, cb) ->
    chatSession.relationMeta.get 'type', (err, type) ->
      relationsByChat[chatSession.chatId] = type
      cb err

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions) ->
      return next err, {} if err?
      async.forEach chatSessions, lookUpRelation, (err) ->
        next err, relationsByChat
