async = require 'async'
pulsar = config.require 'load/pulsar'
stoic = require 'stoic'
{Session, Chat, ChatSession} = stoic.models

module.exports = (channelName) ->

  # create a channel
  channel = pulsar.channel channelName

  # when a message is received, add it to the history and push to listeners
  channel.on 'clientMessage', (contents) ->

    sess = Session.get(contents.session)
    chat = Chat.get(channelName)
    return unless sess and chat

    # get user's identity and operators present
    async.parallel [
      sess.chatName.get
      ChatSession.getByChat channelName
    ], (err, [username, sessions]) ->
      operators = (op.sessionId for op in sessions)

      # push history data
      history =
        message: contents.message
        username: username
        timestamp: Date.now()
      chat.history.rpush history, ->
        # notify operators
        async.forEach operators, (op, cb) ->
          Session.get(op).unreadMessages.incrby channelName, 1, cb

        channel.emit 'serverMessage', history
