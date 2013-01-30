stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions=[]) ->
      if (chatSessions.any (sess) -> sess.chat.id is chatId)
        return done err, {accessAllowed: true}
      done err, {accessAllowed: false}
