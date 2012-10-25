messageReceived = config.require 'services/chats/messageReceived'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
module.exports = (res, {chatId, sessionId, message}) ->
  messageReceived chatId, sessionId, message, ->
    res.reply null, 'OK'
