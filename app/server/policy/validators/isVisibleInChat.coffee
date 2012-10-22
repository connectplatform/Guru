stoic = require 'stoic'
{Session, ChatSession} = stoic.models

module.exports = (args, cookies, cb) ->
  [chatId] = args
  return cb 'expects arg: chatId' unless chatId?
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).get(sessionId, chatId).relationMeta.get 'isWatching', (err, isWatching) ->
      return cb 'you are not visible in this chat' unless isWatching is 'false'
      cb()
