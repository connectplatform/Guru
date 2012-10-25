stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = ({chatId, sessionId}, done) ->
  metaInfo =
    isWatching: 'false'
    type: 'invite'
    requestor: sessionId

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).add sessionId, chatId, metaInfo, (err) ->
      done err
