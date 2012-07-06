module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
<<<<<<< HEAD
  operatorId = unescape res.cookie('session')

  # add operator to chat list
  redis.chats.operatorArrived chatId, operatorId, (err, data) ->
    console.log "Error adding operator in joinChat: #{err}" if err

    # add chat to operator's list of open chats
    {Operator} = redgoose.models
    Operator.get(operatorId).chats.add chatId, (err, data) ->

=======
  operatorId = unescape(res.cookie('session'))
  {Chat, Operator} = redgoose.models
  chat = Chat.get(chatId)
  chat.operators.add operatorId, (err, data)->
    console.log "Error adding operator in joinChat: #{err}" if err
    Operator.get(operatorId).chats.add chatId, (err, data)->
>>>>>>> unstable
      console.log "Error adding chat to operator in joinChat: #{err}" if err
      res.send null, true
