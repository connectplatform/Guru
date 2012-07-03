module.exports = (res, chatId, options) ->
  redis = require '../../redis'
  operatorId = unescape(res.cookie('session'))
  redis.chats.operatorArrived chatId, operatorId, (err, data)->
    console.log "Error adding operator in joinChat: #{err}" if err
    redis.operators.addChat operatorId, chatId, (err, data)->
      console.log "Error adding chat to operator in joinChat: #{err}" if err
      res.send null, true