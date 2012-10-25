stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (args, next) ->
  {chatId, sessionId} = args
  return next 'expects arg: chatId' unless chatId?
  return next 'expects cookie: {session: sessionId}' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
      return next 'you are not invited to this transfer' unless relationType is 'transfer'
      next null, args
