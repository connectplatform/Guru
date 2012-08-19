stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (res, chatId) ->
  operatorId = unescape res.cookie('session')
  relationMeta =
    isWatching: 'false'
    type: 'member'
  ChatSession.add operatorId, chatId, relationMeta, (err) ->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.reply null, true
