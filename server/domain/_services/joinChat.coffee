module.exports = (res, chatId, options) ->
  redis = require '../../redis'
  redgoose = require 'redgoose'
  operatorId = unescape res.cookie('session')
  redis.chats.operatorArrived chatId, operatorId, (err, data) ->
    console.log "Error adding operator in joinChat: #{err}" if err

    {Operator} = redgoose.models
    Operator.get(operatorId).chats.add chatId, (err, data) ->
      console.log "Error adding chat to operator in joinChat: #{err}" if err
      res.send null, true
