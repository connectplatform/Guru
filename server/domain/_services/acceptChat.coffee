redgoose = require 'redgoose'

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))
  {Chat, ChatSession} = redgoose.models

  Chat.get(chatId).status.getset 'active', (err, status) ->
    if status is 'active'
      res.send null, {status:"ALREADY ACCEPTED", chatId: chatId}
    else
      ChatSession.add operatorId, chatId, isWatching: 'false', (err)->
        console.log "Error adding ChatSession in acceptChat: #{err}" if err
        res.send null, {status:"OK", chatId: chatId}
