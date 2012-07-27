redgoose = require 'redgoose'
{ChatSession} = redgoose.models

module.exports = (req, cb) ->
  [chatId] = req.args
  return cb 'expects arg: chatId' unless chatId?
  sessionId = req.cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  ChatSession.get(sessionId, chatId).relationMeta.get 'type', (err, relationType) ->
    return cb 'you are not a member of this chat' unless relationType is 'member'
    cb()
