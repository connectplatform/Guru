stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res, chatId, isWatching='false') ->
  sessionId = res.cookie 'session'
  relationMeta =
    isWatching: isWatching
    type: 'member'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).add sessionId, chatId, relationMeta, (err) ->
      if err
        meta =
          error: err
          sessionId: sessionId
          chatId: chatId
          relationMeta: relationMeta
        config.log.error 'Error adding ChatSession in joinChat', meta

      res.reply null, true
