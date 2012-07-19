async = require 'async'
pulsar = require '../pulsar'
redgoose = require 'redgoose'
{Session, Chat, OperatorChat} = redgoose.models

module.exports = (channelName) ->

  # create a channel
  channel = pulsar.channel channelName

  # when a message is received, add it to the history and push to listeners
  channel.on 'clientMessage', (contents) ->

    sess = Session.get(contents.session)
    chat = Chat.get(channelName)

    # get user's identity and operators present
    async.parallel [
      sess.chatName.get
      OperatorChat.getOperatorsByChat channelName
    ], (err, [username, operators]) ->
      console.log "Error getting chat name from cache: #{err}" if err
      operators ?= {}
      operators = (sessionID for sessionID of operators)

      # push history data
      history =
        message: contents.message
        username: username
        timestamp: Date.now()
      chat.history.rpush history, ->

      # notify operators
      async.forEach operators, (op, cb) ->
        Session.get(op).unreadChats.incrby channelName, 1, cb

      channel.emit 'serverMessage', history
