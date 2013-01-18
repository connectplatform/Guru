stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['isWatching']
  service: ({chatId, isWatching, sessionId, accountId}, done) ->
    relationMeta =
      isWatching: isWatching
      type: 'member'

    ChatSession(accountId).add sessionId, chatId, relationMeta, (err) ->
      if err
        meta =
          error: err
          sessionId: sessionId
          chatId: chatId
          relationMeta: relationMeta
        config.log.error 'Error adding ChatSession in joinChat', meta
        return done 'Error joining chat.'

      done null, true
