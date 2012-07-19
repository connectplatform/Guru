redgoose = require 'redgoose'
{Chat, ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))

  ChatSession.remove operatorId, chatId, (err) ->
    Chat.get(chatId).status.get (err, status) ->
      if status is 'active'
        Chat.get(chatId).status.set 'waiting', (err) ->
          console.log "Error setting chat status: #{err}" if err?
          res.send err, chatId
      else
        res.send err, chatId