stoic = require 'stoic'

module.exports = (res, chatId) ->
  {Session, ChatSession} = stoic.models

  newMeta =
    type: 'member'
    isWatching: 'false'

  sessionId = res.cookie 'session'

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.mset newMeta, (err) ->
      res.reply err, chatId
