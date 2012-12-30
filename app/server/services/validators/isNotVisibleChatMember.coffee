stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (args, next) ->
  {chatId, sessionId} = args
  return next 'expects arg: chatId' unless chatId?
  return next 'expects cookie: {session: sessionId}' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
      if relationType is 'member'
        ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'isWatching', (err, isWatching) ->
          return next 'you are already a visible member of this chat' unless isWatching is 'true'
          next null, args
      else
        next null, args
