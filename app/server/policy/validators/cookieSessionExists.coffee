sessionIdIsValid = require './sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionId = cookies?.session
  sessionIdIsValid sessionId, cookies, cb
