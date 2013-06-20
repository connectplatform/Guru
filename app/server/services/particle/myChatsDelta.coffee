{removalEvent} = config.require 'lib/eventConstructors'
watcher = config.require 'load/mongoWatch'
logger = config.require 'lib/logger'

Queue = require 'queue'
{curry} = config.require 'lib/util'

# ENTER THE LION'S DEN
module.exports =
  required: ['chatIds', 'session']
  service: (identity, listener) ->

    # establish a queue for this listener so we can process its events in order
    q = new Queue {timeout: 200, concurrency: 1}

    # receive updates for chats we are in
    watcher.watch "#{config.mongo.dbName}.chats", (event) ->
      event = event.clone()
      event.oplist = event.oplist.filter (op) -> op.id in identity.chatIds
      if event.oplist.length > 0
        listener(event)

    # when our chat membership changes
    watcher.watch "#{config.mongo.dbName}.chatsessions", (event) ->

      for op in event?.oplist
        #logger.grey 'chatSession:'.cyan, op.operation, op.id, op.path

        # dispatch based on operation
        if op.operation is 'set' and op.path is '.'
          handler = 'particle/onNewChatSession'
        else if op.operation is 'unset' and op.path is '.'
          handler = 'particle/onRemoveChatSession'

        q.push curry config.services[handler], {identity, op, listener}
