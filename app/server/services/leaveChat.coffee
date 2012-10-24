stoic = require 'stoic'
{Chat, ChatSession, Session} = stoic.models

module.exports = (res, chatId) ->
  sessionId = res.cookie 'session'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).remove sessionId, chatId, (err) ->
      config.log.error 'Error removing chatSession in leaveChat', {error: err, chatId: chatId, sessionId: sessionId} if err

      Session(accountId).get(sessionId).operatorId.get (err, operatorId) ->
        return res.reply() unless operatorId

        Chat(accountId).get(chatId).status.get (err, status) ->
          config.log.error 'Error getting chat status in leaveChat', {error: err, chatId: chatId} if err

          ChatSession(accountId).getByChat chatId, (err, chatSessions) ->
            config.log.error 'Error getting chatSessions for chat in leaveChat', {error: err, chatId: chatId} if err

            if status is 'active' and chatSessions.length is 1
              Chat(accountId).get(chatId).status.set 'waiting', (err) ->
                config.log.error 'Error setting chatStatus in leaveChat', {error: err, chatId: chatId} if err
                res.reply err, chatId
            else
              res.reply err, chatId
