redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, sessionId, chatId) ->
  ChatSession.getBySession sessionId, (err, chatSessions) ->
    for chatSession in chatSessions
      return res.send err, true if chatSession.session.id is sessionId
    res.send err, false
