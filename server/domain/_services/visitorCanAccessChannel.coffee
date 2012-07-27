redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, sessionId, chatId) ->
  ChatSession.getBySession sessionId, (err, chatSessions) ->
    for chatSession in chatSessions
      console.log "chatSession.chat.id: #{chatSession.chat.id}"
      return res.send err, true if chatSession.chat.id is chatId
    res.send err, false
