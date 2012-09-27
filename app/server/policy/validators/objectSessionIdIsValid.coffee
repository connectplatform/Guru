sessionIdIsValid = require './sessionIdIsValid'

module.exports = (args, cookies, cb) ->
  sessionIdIsValid args?.sessionId, cookies, cb
