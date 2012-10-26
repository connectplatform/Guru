stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, isWatching, sessionId}, done) ->
  relationMeta =
    isWatching: (if isWatching then 'true' else 'false')
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

      done null, true
