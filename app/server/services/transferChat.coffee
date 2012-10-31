stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports =
  required: ['chatId', 'targetSessionId', 'accountId', 'sessionId']
  service: ({chatId, targetSessionId, accountId, sessionId}, done) ->
    metaInfo =
      isWatching: 'false'
      type: 'transfer'
      requestor: sessionId

    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
