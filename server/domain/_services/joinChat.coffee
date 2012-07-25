redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (res, chatId) ->
  operatorId = unescape res.cookie('session')
  relationMeta =
    isWatching: 'false'
    type: 'member'
  ChatSession.add operatorId, chatId, relationMeta, (err) ->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.send null, true
