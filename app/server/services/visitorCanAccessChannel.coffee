stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions=[]) ->
      if (chatSessions.any (sess) -> sess.chat.id is chatId)
        return res.reply err, true
      res.reply err, false
