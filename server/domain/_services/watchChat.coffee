#TODO this is 5 characters different from joinChat.  Refactor.
stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))
  relationMeta =
    isWatching: 'true'
    type: 'member'
  ChatSession.add operatorId, chatId, relationMeta, (err)->
    console.log "Error adding ChatSession in joinChat: #{err}" if err
    res.reply null, true
