{removalEvent} = config.require 'lib/eventConstructors'
logger = config.require 'lib/logger'

module.exports =
  required: ['identity', 'op', 'listener']
  service: ({identity, op, listener}, done) ->

    # if we have a relationship with this chatSession ID
    chatId = identity.chatRelation[op.id]
    if chatId?

      # tell the collector to remove the chat
      listener removalEvent 'chats', {_id: chatId}

      # remove the subscription
      identity.chatIds.remove chatId
      delete identity.chatRelation[op.id]
      #logger.blue 'unsetting:', {chatId}
    done()
