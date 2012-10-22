chatIdIsValid = require './helpers/chatIdIsValid'

module.exports = (args, cookies, cb) ->
  chatId = args?[0]?.chatId
  return cb 'expects chatId field in argument object' unless chatId?

  chatIdIsValid cookies.session, chatId, cb
