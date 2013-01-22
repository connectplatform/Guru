async = require 'async'
stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  service: ({chatId, sessionId, accountId}, next) ->
    async.parallel {
      relationType: ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type'
      isWatching: ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'isWatching'
    }, next
