stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports =
  required: ['chatId', 'accountId', 'sessionId', 'targetSessionId']
  service: ({chatId, accountId, sessionId, targetSessionId}, done) ->
    metaInfo =
      isWatching: 'false'
      type: 'invite'
      requestor: sessionId

    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
