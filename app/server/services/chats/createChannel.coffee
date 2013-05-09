module.exports = (chatId) ->
  messageReceived = config.service 'chats/messageReceived'
  channel = pulsar.channel chatId

  channel.on 'clientMessage', (contents) ->
    messageReceived {chatId: chatId, sessionId: contents.session, message: contents.message}, (err) ->
      config.log.warn "Error receiving chat message.", {error: err} if err
