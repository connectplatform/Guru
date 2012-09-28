sessionIdIsValid = require './helpers/sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionId = args?[1]
  return cb 'expects valid session id as second argument' unless sessionId?

  sessionIdIsValid sessionId, cb
