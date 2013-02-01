stoic = require 'stoic'

removeUnanswered = config.require 'services/operator/removeUnanswered'

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: (params, done) ->
    {Chat} = stoic.models
    {chatId, sessionId, accountId} = params

    Chat(accountId).get(chatId).status.getset 'active', (err, status) ->

      if err
        config.log.warn new Error 'Error getsetting chat status in acceptChat', {error: err, chatId: chatId}
        done null, {status: "ERROR", chatId: chatId}

      else if status is 'active'
        done null, {status: "ALREADY ACCEPTED", chatId: chatId}

      else

        config.services['joinChat'] params, (err) ->
          return done err if err

          removeUnanswered accountId, chatId, (err, status) ->
            if err
              config.log.error 'Error removing chat from unanswered chats in acceptChat', {error: err, chatId: chatId}
            done null, {status: "OK", chatId: chatId}
