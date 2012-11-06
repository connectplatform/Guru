#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports =
  required: ['chatId', 'sessionId', 'message']
  service: ({chatId, sessionId, message}, done) ->
    messageReceived = config.service 'chats/messageReceived'
    messageReceived {chatId: chatId, sessionId: sessionId, message: message}, ->
      done null, 'OK'
