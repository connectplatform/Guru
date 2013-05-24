async = require 'async'

# stoic = require 'stoic'
# {Session, Chat, ChatSession} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'chatId']
  optional: ['message']
  service: ({sessionId, accountId, chatId, message}, done) ->
    # get user's identity and operators present
    async.parallel [
      Session(accountId).get(sessionId).chatName.get
      ChatSession(accountId).getByChat chatId

    ], (err, [username, chatSessions]) ->
      console.log 'here'
      chatSessions ?= []
      return done err if err

      operators = (op.sessionId for op in chatSessions)

      # push history data
      said =
        message: message
        username: username
        timestamp: Date.now()

      Chat(accountId).get(chatId).history.rpush said, ->
        done()

        # asynchronous notifications
        async.forEach operators, (op, next) ->
          Session(accountId).get(op).unreadMessages.incrby chatId, 1, next

        channel = pulsar.channel chatId
        channel.emit 'serverMessage', said
