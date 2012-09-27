messageReceived = config.require 'services/chats/messageReceived'

module.exports = (res, {chatId, sessionId, message}) ->
  messageReceived chatId, sessionId, message, ->
    res.reply null, 'OK'
