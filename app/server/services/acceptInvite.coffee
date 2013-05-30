db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->
    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      done err, null if err

      chatSession?.relation = 'Member'
      chatSession?.save done
