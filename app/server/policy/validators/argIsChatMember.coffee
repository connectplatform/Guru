sessionIsChatMember = require './helpers/sessionIsChatMember'

module.exports = (args, cookies, cb) ->
  chatId = args?[0]
  return cb 'expects arg: chatId' unless chatId?
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  sessionIsChatMember chatId, sessionId, cb
