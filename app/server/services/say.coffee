module.exports =
  required: ['chatId', 'sessionId', 'message']
  service: (params, done) ->
    messageReceived = config.service 'chats/messageReceived'
    messageReceived params, ->
      done null, {status: 'OK'}
