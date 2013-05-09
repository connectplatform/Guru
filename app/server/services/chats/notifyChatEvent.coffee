module.exports =
  required: ['sessionId', 'accountId', 'chatId', 'message']
  service: ({chatId, message}, done) ->
    channel = pulsar.channel chatId
    body =
      message: message
      type: 'notification'
      timestamp: new Date().getTime()

    channel.emit 'serverMessage', body
    done()
