db = config.require 'load/mongo'
{ChatSession} = db.models

module.exports =
  required: ['chatId', 'sessionId']
  service: ({chatId, sessionId}, done) ->
    ChatSession.remove {sessionId, chatId}, (err) ->
      done err
