redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'
  ChatSession.getBySession sessionId, (err, chatSessions=[]) ->
    if (chatSessions.any (sess) -> sess.chat.id is chatId)
      return res.reply err, true
    res.reply err, false
