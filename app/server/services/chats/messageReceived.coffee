async = require 'async'
pulsar = config.require 'load/pulsar'

stoic = require 'stoic'
{Session, Chat, ChatSession} = stoic.models

module.exports = (chatId, sessionId, message, done) ->

  sess = Session.get sessionId
  chat = Chat.get chatId

  return unless sess and chat

  # get user's identity and operators present
  async.parallel [
    sess.chatName.get
    ChatSession.getByChat chatId

  ], (err, [username, chatSessions]) ->
    chatSessions ?= []
    config.log.error 'Error getting chat name and session in messageReceived', {error: err, chatId: chatId, username: username, chatSessions: chatSessions} if err
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
        Session.get(op).unreadMessages.incrby chatId, 1, next

      channel = pulsar.channel chatId
      channel.emit 'serverMessage', said
