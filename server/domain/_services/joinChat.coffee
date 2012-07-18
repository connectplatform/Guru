redgoose = require 'redgoose'
{SessionChat} = redgoose.models

module.exports = (res, chatId, options) ->
  operatorId = unescape res.cookie('session')
  SessionChat.add operatorId, chatId, isWatching: 'false', (err) ->
    console.log "Error adding SessionChat in joinChat: #{err}" if err
    res.send null, true
