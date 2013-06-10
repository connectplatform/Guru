db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  service: ({sessionId, chatId}, done) ->
    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      done err, null if err

      chatSession?.relation = 'Member'
      chatSession?.save done
