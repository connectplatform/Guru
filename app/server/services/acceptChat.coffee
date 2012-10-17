stoic = require 'stoic'

removeUnanswered = config.require 'services/operator/removeUnanswered'

module.exports = (res, chatId) ->
  sessionId = unescape(res.cookie('session'))
  {Chat, ChatSession} = stoic.models

  Chat.get(chatId).status.getset 'active', (err, status) ->
    config.log.warn 'Error getsetting chat status in acceptChat', {error: err, chatId: chatId} if err

    if status is 'active'
      res.reply null, {status:"ALREADY ACCEPTED", chatId: chatId}

    else
      relationMeta =
        isWatching: 'false'
        type: 'member'

      ChatSession.add sessionId, chatId, relationMeta, (err)->
        config.log.error 'Error adding ChatSession in acceptChat', {error: err, sessionId: sessionId, chatId: chatId, relationMeta: relationMeta} if err

        removeUnanswered chatId, (err, status) ->
          config.log.error 'Error removing chat from unanswered chats in acceptChat', {error: err, chatId: chatId} if err

          res.reply null, {status:"OK", chatId: chatId}
