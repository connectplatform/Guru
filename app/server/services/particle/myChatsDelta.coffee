createEvent = config.require 'lib/createEvent'
watcher = config.require 'load/mongoWatch'
logger = config.require 'lib/logger'

# ENTER THE LION'S DEN
module.exports =
  required: ['chatIds', 'session']
  service: (identity, listener) ->

    # receive updates for chats we are in
    watcher.watch "#{config.mongo.dbName}.chats", (event) ->
      event = event.clone()
      event.oplist = event.oplist.filter (op) -> op.id in identity.chatIds
      if event.oplist.length > 0
        listener(event)

    # when our chat membership changes
    watcher.watch "#{config.mongo.dbName}.chatsessions", (event) ->

      # did our Session get a new ChatSession?
      op = event?.oplist?[0]
      chatId = op?.data?.chatId?.toString()
      sessionId = op?.data?.sessionId?.toString()
      if op.operation is 'set' and op.path is '.' and chatId? and sessionId is identity.session._id

        # retrieve the corresponding chat
        config.services['chats/getChats'] {chatIds: [chatId]}, (err, args) ->
          chat = args?.chats?[0]
          if chat

            # send a new chat event to the collector
            listener createEvent(chat)

            # update our subscription
            identity.chatIds.push chatId
