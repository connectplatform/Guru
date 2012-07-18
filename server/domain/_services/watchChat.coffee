#TODO this is 5 characters different from joinChat.  Refactor.

module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {SessionChat} = redgoose.models
  SessionChat.add operatorId, chatId, isWatching: 'true', (err)->
    console.log "Error adding SessionChat in joinChat: #{err}" if err
    res.send null, true
