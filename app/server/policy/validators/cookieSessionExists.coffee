sessionIdIsValid = require './helpers/sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionId = cookies?.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?
  sessionIdIsValid sessionId, cb
