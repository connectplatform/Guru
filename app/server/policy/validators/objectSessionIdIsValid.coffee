sessionIdIsValid = require './helpers/sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionId = args?[0]?.sessionId
  return cb "Expects sessionId field in argument object" unless sessionId?
  sessionIdIsValid sessionId, cb
