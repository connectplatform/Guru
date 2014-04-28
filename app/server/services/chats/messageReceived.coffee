async = require 'async'
pulsar = config.require 'load/pulsar'

stoic = require 'stoic'
{Session, Chat, ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['message']
  service: ({sessionId, accountId, chatId, message}, done) ->

    # get user's identity and operators present
    async.parallel [
      Session(accountId).get(sessionId).chatName.get
      ChatSession(accountId).getByChat chatId

    ], (err, [username, chatSessions]) ->
      chatSessions ?= []
      return done err if err

      operators = (op.sessionId for op in chatSessions)

      # push history data
      said =
        message: message
        username: username
        timestamp: Date.now()

      Chat(accountId).get(chatId).history.rpush said, ->
        # asynchronous notifications
        updateUnreadMessages = (op, next) ->
          Session(accountId).get(op).unreadMessages.incrby chatId, 1, next
        async.forEach operators, updateUnreadMessages, () ->

          channel = pulsar.channel chatId
          channel.emit 'serverMessage', said

          done()
