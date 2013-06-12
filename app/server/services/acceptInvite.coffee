db = config.require 'load/mongo'
{ChatSession, Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId']
  service: ({sessionId, chatId}, done) ->
    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      return done err, null if err or not chatSession

      chatSession?.relation = 'Member'
      chatSession?.save done
