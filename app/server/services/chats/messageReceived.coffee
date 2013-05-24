async = require 'async'

db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['message']
  service: ({sessionId, accountId, chatId, message}, done) ->
    # get user's identity and operators present
    async.parallel {
        chat: (next) -> Chat.findById chatId, next
        chatSession: (next) -> ChatSession.findOne {sessionId, chatId}, next
        session: (next) -> Session.findById sessionId, next
      }, (err, {chat, chatSession, session}) ->
        return done err if err

        said =
          message: message
          username: session.username
          timestamp: Date.now()

        chat.history.push said
        chat.save done

    # ], (err, [username, chatSessions]) ->
      # console.log 'here'
      # chatSessions ?= []
      # return done err if err

      # operators = (op.sessionId for op in chatSessions)

      # # push history data
      # said =
      #   message: message
      #   username: username
      #   timestamp: Date.now()

      # Chat(accountId).get(chatId).history.rpush said, ->
      #   done()

      #   # asynchronous notifications
      #   async.forEach operators, (op, next) ->
      #     Session(accountId).get(op).unreadMessages.incrby chatId, 1, next

      #   channel = pulsar.channel chatId
      #   channel.emit 'serverMessage', said
