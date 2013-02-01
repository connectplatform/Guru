stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId', 'targetSessionId']
  service: ({sessionId, accountId, chatId, targetSessionId}, done) ->
    metaInfo =
      isWatching: 'false'
      type: 'invite'
      requestor: sessionId

    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
