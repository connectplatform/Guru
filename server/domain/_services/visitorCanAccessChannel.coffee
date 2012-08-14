redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'
  ChatSession.getBySession sessionId, (err, chatSessions) ->
    for chatSession in chatSessions
      return res.send err, true if chatSession.chat.id is chatId
    res.send err, false
