stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, sessionId}, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions=[]) ->
      if (chatSessions.any (sess) -> sess.chat.id is chatId)
        return done err, true
      done err, false
