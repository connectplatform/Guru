module.exports =
  required: ['chatId', 'sessionId', 'message']
  service: (params, done) ->
    messageReceived = config.service 'chats/messageReceived'
    messageReceived params, (err) ->
      return done err if err
      done null, {status: 'OK'}
