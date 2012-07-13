module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {Chat, OperatorChat} = redgoose.models

  Chat.get(chatId).unanswered.getset 'false', (err, isUnanswered) ->
    if isUnanswered is 'false'
      res.send null, {status:"ALREADY ACCEPTED", chatId: chatId}
    else
      OperatorChat.add operatorId, chatId, 'false', (err)->
        console.log "Error adding OperatorChat in acceptChat: #{err}" if err
        res.send null, {status:"OK", chatId: chatId}