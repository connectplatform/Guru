module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {Chat, Operator} = redgoose.models
  chat = Chat.get(chatId)
  chat.operators.add operatorId, (err, data)->
    console.log "Error adding operator in joinChat: #{err}" if err
    Operator.get(operatorId).chats.add chatId, (err, data)->
      console.log "Error adding chat to operator in joinChat: #{err}" if err
      res.send null, true
