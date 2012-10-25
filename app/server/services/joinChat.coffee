stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, isWatching, sessionId}, done) ->
  console.log 'entered joinChat'
  console.log 'sessionId: ', sessionId
  console.log 'chatId: ', chatId
  isWatching = isWatching or 'false'
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

      console.log 'leaving joinChat'
      done null, true
