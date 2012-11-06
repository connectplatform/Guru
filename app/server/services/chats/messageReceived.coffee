async = require 'async'
pulsar = config.require 'load/pulsar'

stoic = require 'stoic'
{Session, Chat, ChatSession} = stoic.models

module.exports =
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId, message}, done) ->

    Session.accountLookup.get sessionId, (err, accountId) ->
      sess = Session(accountId).get sessionId
      chat = Chat(accountId).get chatId

      return unless sess and chat

      # get user's identity and operators present
      async.parallel [
        sess.chatName.get
        ChatSession(accountId).getByChat chatId

      ], (err, [username, chatSessions]) ->
        chatSessions ?= []
        if err
          meta =
            error: err
            chatId: chatId
            username: username
            chatSessions: chatSessions
          config.log.error 'Error getting chat name and session in messageReceived', meta

        operators = (op.sessionId for op in chatSessions)

        # push history data
        said =
          message: message
          username: username
          timestamp: Date.now()

        chat.history.rpush said, ->
          done()

          # asynchronous notifications
          async.forEach operators, (op, next) ->
            Session(accountId).get(op).unreadMessages.incrby chatId, 1, next

          channel = pulsar.channel chatId
          channel.emit 'serverMessage', said
