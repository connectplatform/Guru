stoic = require 'stoic'

removeUnanswered = config.require 'services/operator/removeUnanswered'

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({chatId, sessionId, accountId}, done) ->
    {Session, Chat, ChatSession} = stoic.models

    Chat(accountId).get(chatId).status.getset 'active', (err, status) ->
      config.log.warn 'Error getsetting chat status in acceptChat', {error: err, chatId: chatId} if err

      if status is 'active'
        done null, {status:"ALREADY ACCEPTED", chatId: chatId}

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
            if err
              config.log.error 'Error removing chat from unanswered chats in acceptChat', {error: err, chatId: chatId}
            done null, {status:"OK", chatId: chatId}
