async = require 'async'
pulsar = config.require 'load/pulsar'
stoic = require 'stoic'
{Session, Chat, ChatSession} = stoic.models

module.exports = (chatId, sessionId, message) ->

  sess = Session.get sessionId
  chat = Chat.get chatId

  return unless sess and chat

  # get user's identity and operators present
  async.parallel [
    sess.chatName.get
    ChatSession.getByChat chatId
  ], (err, [username, sessions]) ->
    console.log "Error getting chat name from cache: #{err}" if err
    operators = (op.sessionId for op in sessions)

    # push history data
    said =
      message: message
      username: username
      timestamp: Date.now()
    chat.history.rpush said, ->
      # notify operators
      async.forEach operators, (op, cb) ->
        Session.get(op).unreadMessages.incrby chatId, 1, cb

      channel = pulsar.channel chatId
      channel.emit 'serverMessage', said
