stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (args, cookies, cb) ->
  [chatId] = args
  return cb 'expects arg: chatId' unless chatId?
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
      if relationType is 'member'
        ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'isWatching', (err, isWatching) ->
          return cb 'you are already a visible member of this chat' unless isWatching is 'true'
          cb()
      else
        cb()
