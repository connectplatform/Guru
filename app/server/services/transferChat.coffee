stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, targetSessionId, sessionId}, done) ->
  metaInfo =
    isWatching: 'false'
    type: 'transfer'
    requestor: sessionId

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).add targetSessionId, chatId, metaInfo, (err) ->
      done err
