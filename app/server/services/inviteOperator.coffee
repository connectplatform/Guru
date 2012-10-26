stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, sessionId, targetSessionId}, done) ->
  metaInfo =
    isWatching: 'false'
    type: 'invite'
    requestor: sessionId

  Session.accountLookup.get targetSessionId, (err, accountId) ->
    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
