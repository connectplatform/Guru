db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId', 'chatId']
  service: ({sessionId, chatId}, done) ->
    ChatSession.findOne {sessionId, chatId}, (err, chatSession) ->
      return done err if err
      accessAllowed = chatSession?
      done err, {accessAllowed}
