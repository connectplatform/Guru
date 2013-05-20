async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'chatId']
  service: ({chatId, sessionId}, next) ->
    # Chat.findById chatId, (err, chat) ->
    #   Session.findById sessionId, (err, session) ->
    #     assert session.accountId == chat.accountId
    #     next 'accountId ', null
    ChatSession.findOne {chatId, sessionId}, (err, chatSession) ->
      if err?
        next err, null
      else if chatSession?
        next null, {relation: chatSession.relation}
      else
        next null, null