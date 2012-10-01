sessionIdIsValid = require './helpers/sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionId = args?[0]
  return cb 'expects sessionId as first argument' unless sessionId?
  sessionIdIsValid sessionId, cb
