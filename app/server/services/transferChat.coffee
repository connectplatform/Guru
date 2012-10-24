stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (res, chatId, sessionId) ->
  requestorSess = res.cookie 'session'
  metaInfo =
    isWatching: 'false'
    type: 'transfer'
    requestor: requestorSess

  Session.accountLookup.get requestorSess, (err, accountId) ->
    ChatSession(accountId).add sessionId, chatId, metaInfo, (err) ->
      res.reply err
