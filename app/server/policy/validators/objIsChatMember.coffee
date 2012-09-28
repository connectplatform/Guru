sessionIsChatMember = require './helpers/sessionIsChatMember'

module.exports = (args, cookies, cb) ->
  chatId = args?[0]?.chatId
  return cb 'expects argument to contain field: chatId' unless chatId?
  sessionId = args?[0]?.sessionId
  return cb 'expects argument to contain field: sessionId' unless sessionId?

  sessionIsChatMember chatId, sessionId, cb
