db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  dependencies:
    services: ['operator/removeUnanswered', 'joinChat']
  required: ['sessionSecret', 'sessionId', 'accountId', 'chatId']
  service: (params, done, {services}) ->
    {chatId, sessionId, accountId} = params
    removeUnanswered = services['operator/removeUnanswered']
    joinChat = services['joinChat']

    Chat.findById chatId, (err, chat) ->
      if err
        config.log.warn new Error 'Error getsetting chat status in acceptChat', {error: err, chatId: chatId}
        done null, {status: "ERROR", chatId: chatId}
      else if chat.status is 'Active'
        done null, {status: "ALREADY ACCEPTED", chatId: chatId}
      else
        joinChat params, (err, _) ->
          return done err if err
          removeUnanswered {accountId, chatId}, (err, status) ->
            if err
              config.log.error 'Error removing chat from unanswered chats in acceptChat', {error: err, chatId: chatId}
            done null, {status: "OK", chatId: chatId}
