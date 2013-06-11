async = require 'async'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  service: ({chatId, sessionId}, next) ->
    console.log 'getRelationToChat', {sessionId}
    ChatSession.findOne {chatId, sessionId}, (err, chatSession) ->
      console.log 'getRelationToChat, found chatSession:', {chatSession}
      if err?
        next err, null
      else if chatSession?
        next null, {relation: chatSession.relation}
      else
        next null, null