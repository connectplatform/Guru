stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({sessionId, accountId, chatId}, done) ->
    newMeta =
      type: 'member'
      isWatching: 'false'

    ChatSession(accountId).get(sessionId, chatId).relationMeta.mset newMeta, (err) ->
      done err
