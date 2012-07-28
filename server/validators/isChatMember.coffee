redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (args, cookies, cb) ->
  [chatId] = args
  return cb 'expects arg: chatId' unless chatId?
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  ChatSession.get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
    return cb 'you are not a member of this chat' unless relationType is 'member'
    cb()
