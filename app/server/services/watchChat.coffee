joinChat = config.require 'services/joinChat'

module.exports = (res, chatId) ->
  joinChat res, chatId, 'true'
