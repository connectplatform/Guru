#TODO this is 5 characters different from joinChat.  Refactor.
redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId, options) ->
  operatorId = unescape(res.cookie('session'))

  ChatSession.add operatorId, chatId, isWatching: 'true', (err)->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.send null, true
