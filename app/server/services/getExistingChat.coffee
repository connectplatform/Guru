db = config.require 'load/mongo'
{Session, ChatSession} = db.models

module.exports =
  optional: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    return done null, {reason: 'no session ID'} unless sessionId
    return done null, {reason: 'no account ID'} unless accountId

    ChatSession.find {sessionId}, (err, chatSessions) ->
      config.warn "Error getting existing chat:", {error: err} if err
      done err, null if err

      found = chatSessions?[0]?.chatId
      return done null, {chatId: found}
