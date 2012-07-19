redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId, options) ->
  operatorId = unescape res.cookie('session')
  ChatSession.add operatorId, chatId, isWatching: 'false', (err) ->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.send null, true
