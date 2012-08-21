stoic = require 'stoic'

module.exports = (res, chatId) ->
  operatorId = unescape(res.cookie('session'))
  {Chat, ChatSession} = stoic.models

  Chat.get(chatId).status.getset 'active', (err, status) ->
    if status is 'active'
      res.reply null, {status:"ALREADY ACCEPTED", chatId: chatId}
    else
      relationMeta =
        isWatching: 'false'
        type: 'member'
      ChatSession.add operatorId, chatId, relationMeta, (err)->
        console.log "Error adding ChatSession in acceptChat: #{err}" if err
        res.reply null, {status:"OK", chatId: chatId}
