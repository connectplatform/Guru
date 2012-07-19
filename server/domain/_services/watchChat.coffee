#TODO this is 5 characters different from joinChat.  Refactor.

module.exports = (res, chatId, options) ->
  redgoose = require 'redgoose'
  operatorId = unescape(res.cookie('session'))
  {ChatSession} = redgoose.models
  ChatSession.add operatorId, chatId, isWatching: 'true', (err)->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.send null, true
