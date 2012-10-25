messageReceived = config.require 'services/chats/messageReceived'

module.exports = ({chatId, sessionId, message}, done) ->
  messageReceived chatId, sessionId, message, ->
    done null, 'OK'
