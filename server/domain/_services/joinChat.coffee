module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {Chat, Operator} = redgoose.models
  chat = Chat.get(chatId)
  console.log "got a chat"
  chat.operators.add operatorId, (err, data)->
    console.log "Error adding operator in joinChat: #{err}" if err
    operator = Operator.get(operatorId)
    console.log "got an operator"
    operator.chats.add chatId, (err, data)->
      console.log "Error adding chat to operator in joinChat: #{err}" if err
      console.log "got to the end"
      res.send null, true