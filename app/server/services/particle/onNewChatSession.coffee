{creationEvent} = config.require 'lib/eventConstructors'
logger = config.require 'lib/logger'

module.exports =
  required: ['identity', 'op', 'listener']
  service: ({identity, op, listener}, done) ->
    chatId = op?.data?.chatId?.toString()
    sessionId = op?.data?.sessionId?.toString()
    if chatId? and sessionId is identity.session._id

      # retrieve the corresponding chat
      config.services['chats/getChats'] {chatIds: [chatId]}, (err, args) ->
        chat = args?.chats?[0]
        if chat

          # send a new chat event to the collector
          listener creationEvent 'chats', chat

          # update our subscription
          identity.chatIds.push chatId
          identity.chatRelation[op.id] = chatId
          #logger.white 'setting:', {relId: op.id, chatId}
        done err

    else
      done()
