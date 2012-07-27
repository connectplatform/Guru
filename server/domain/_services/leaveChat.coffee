redgoose = require 'redgoose'
{Chat, ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))

  ChatSession.remove operatorId, chatId, (err) ->
    Chat.get(chatId).status.get (err, status) ->

      ChatSession.getByChat chatId, (err, chatSessions) ->
        console.log "Error getting chatSessions: #{err}" if err

        if status is 'active' and chatSessions.length is 1
          Chat.get(chatId).status.set 'waiting', (err) ->
            console.log "Error setting chat status: #{err}" if err?
            res.send err, chatId
        else
          res.send err, chatId
