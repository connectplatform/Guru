stoic = require 'stoic'
{ChatSession, Session} = stoic.models

module.exports = (args, next) ->
  {chatId, sessionId} = args
  return next 'required arg: chatId' unless chatId
  return next 'required arg: sessionId' unless sessionId

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
      return next 'you are not a member of this chat' unless relationType is 'member'
      next null, args
