chatIdIsValid = require './chatIdIsValid'

module.exports = (args, cookies, cb) ->
  chatIdIsValid args?.chatId, cookies, cb
