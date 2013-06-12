db = config.require 'load/mongo'
{Session, ChatSession} = db.models

module.exports =
  required: ['sessionSecret']
  optional: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    return done null, {reason: 'no session ID'} unless sessionId

    ChatSession.findOne {sessionId}, {chatId: 1}, (err, chatSession) ->
      config.warn "Error getting existing chat:", {error: err} if err
      return done err, null if err

      return done null, {chatId: chatSession?.chatId}
