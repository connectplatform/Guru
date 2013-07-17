module.exports =
  dependencies:
    services: ['chats/messageReceived']
  required: ['chatId', 'sessionId', 'message']
  service: (params, done, {services}) ->
    messageReceived = services['chats/messageReceived']
    messageReceived params, (err) ->
      return done err if err
      done null, {status: 'OK'}
