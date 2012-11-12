stoic = require 'stoic'
pulsar = config.require 'load/pulsar'

updateChatStatus = config.require 'services/chats/updateChatStatus'
{Chat, ChatSession, Session} = stoic.models

module.exports =
  required: ['accountId', 'chatId', 'sessionId']
  service: ({chatId, sessionId, accountId}, done) ->
    notify = pulsar.channel chatId
    ChatSession(accountId).remove sessionId, chatId, (err) ->
      config.log.error 'Error removing chatSession in leaveChat', {error: err, chatId: chatId, sessionId: sessionId} if err
      notify.emit 'operatorLeave'
      done err, chatId
