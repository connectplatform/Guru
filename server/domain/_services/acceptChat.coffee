module.exports = (res, chatId) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {Chat, SessionChat} = redgoose.models

  Chat.get(chatId).status.getset 'active', (err, status) ->
    if status is 'active'
      res.send null, {status:"ALREADY ACCEPTED", chatId: chatId}
    else
      SessionChat.add operatorId, chatId, isWatching: 'false', (err)->
        console.log "Error adding SessionChat in acceptChat: #{err}" if err
        res.send null, {status:"OK", chatId: chatId}
