stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res, chatId, sessionId) ->
  metaInfo =
    isWatching: 'false'
    type: 'invite'
    requestor: res.cookie 'session'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).add sessionId, chatId, metaInfo, (err) ->
      res.reply err
