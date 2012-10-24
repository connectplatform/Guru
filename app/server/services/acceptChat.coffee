stoic = require 'stoic'

removeUnanswered = config.require 'services/operator/removeUnanswered'

module.exports = (res, chatId) ->
  sessionId = unescape(res.cookie('session'))
  {Session, Chat, ChatSession} = stoic.models

  Session.accountLookup.get sessionId, (err, accountId) ->
    Chat(accountId).get(chatId).status.getset 'active', (err, status) ->
      config.log.warn 'Error getsetting chat status in acceptChat', {error: err, chatId: chatId} if err

      if status is 'active'
        res.reply null, {status:"ALREADY ACCEPTED", chatId: chatId}

      else
        relationMeta =
          isWatching: 'false'
          type: 'member'

        ChatSession(accountId).add sessionId, chatId, relationMeta, (err) ->
          if err
            meta =
              error: err
              sessionId: sessionId
              chatId: chatId
              relationMeta: relationMeta
            config.log.error 'Error adding ChatSession in acceptChat', meta

          removeUnanswered accountId, chatId, (err, status) ->
            config.log.error 'Error removing chat from unanswered chats in acceptChat', {error: err, chatId: chatId} if err

            res.reply null, {status:"OK", chatId: chatId}
