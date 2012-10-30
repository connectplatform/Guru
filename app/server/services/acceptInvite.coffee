stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done) ->
    newMeta =
      type: 'member'
      isWatching: 'false'

    ChatSession(accountId).get(sessionId, chatId).relationMeta.mset newMeta, (err) ->
      done err, chatId
