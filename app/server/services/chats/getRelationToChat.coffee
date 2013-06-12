db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  service: ({chatId, sessionId}, next) ->
    ChatSession.findOne {chatId, sessionId}, (err, chatSession) ->
      if err?
        next err, null
      else if chatSession?
        next null, {relation: chatSession.relation}
      else
        next null, null