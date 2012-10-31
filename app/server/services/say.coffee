messageReceived = config.require 'services/chats/messageReceived'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports =

  required: ['chatId', 'sessionId', 'message']
  service: ({chatId, sessionId, message}, done) ->
    messageReceived chatId, sessionId, message, ->
      done null, 'OK'
