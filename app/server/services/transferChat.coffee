stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
    metaInfo =
      isWatching: 'false'
      type: 'transfer'
      requestor: sessionId

    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
