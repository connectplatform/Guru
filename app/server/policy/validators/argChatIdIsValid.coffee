chatIdIsValid = require './helpers/chatIdIsValid'

module.exports = (args, cookies, cb) ->
  chatId = args?[0]
  return cb 'expects chatId as first argument argument' unless chatId?

  chatIdIsValid chatId, cb
