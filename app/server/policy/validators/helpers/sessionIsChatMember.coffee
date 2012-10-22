stoic = require 'stoic'
{ChatSession, Session} = stoic.models

module.exports = (chatId, sessionId, cb) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
      return cb 'you are not a member of this chat' unless relationType is 'member'
      cb()
