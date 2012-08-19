stoic = require 'stoic'
{ChatSession} = stoic.models

module.exports = (args, cookies, cb) ->
  [chatId] = args
  return cb 'expects arg: chatId' unless chatId?
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  ChatSession.get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
    return cb 'you are not invited to this transfer' unless relationType is 'transfer'
    cb()
