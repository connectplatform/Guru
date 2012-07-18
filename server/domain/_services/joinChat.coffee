redgoose = require 'redgoose'
{OperatorChat} = redgoose.models

module.exports = (res, chatId, options) ->
  operatorId = unescape res.cookie('session')
  OperatorChat.add operatorId, chatId, 'false', (err) ->
    console.log "Error adding OperatorChat in joinChat: #{err}" if err
    res.send null, true
