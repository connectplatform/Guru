module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {OperatorChat} = redgoose.models
  OperatorChat.add operatorId, chatId, 'false', (err)->
    console.log "Error adding OperatorChat in joinChat: #{err}" if err
    res.send null, true