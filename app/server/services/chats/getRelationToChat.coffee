db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['sessionSecret', 'chatId']
  service: ({chatId, sessionSecret}, next) ->
    ChatSession.findOne {chatId, secret: sessionSecret}, (err, chatSession) ->
      if err?
        next err, null
      else if chatSession?
        next null, {relation: chatSession.relation}
      else
        next null, null