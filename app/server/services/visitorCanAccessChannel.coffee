stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['chatId', 'sessionId', 'accountId']
  service: ({chatId, sessionId, accountId}, done) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions=[]) ->
      if (chatSessions.any (sess) -> sess.chat.id is chatId)
        return done err, true
      done err, false
