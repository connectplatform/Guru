stoic = require 'stoic'
{Chat, ChatSession, Session} = stoic.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'
  ChatSession.remove sessionId, chatId, (err) ->

    Session.get(sessionId).operatorId.get (err, operatorId) ->
      return res.reply() unless operatorId
      Chat.get(chatId).status.get (err, status) ->

        ChatSession.getByChat chatId, (err, chatSessions) ->
          console.log "Error getting chatSessions: #{err}" if err

          if status is 'active' and chatSessions.length is 1
            Chat.get(chatId).status.set 'waiting', (err) ->
              console.log "Error setting chat status: #{err}" if err?
              res.reply err, chatId
          else
            res.reply err, chatId
