async = require 'async'
stoic = require 'stoic'
{ChatSession, Chat} = stoic.models
query = config.require 'services/queries/query'

module.exports =

  required: ['accountId', 'sessionId']
  service: ({accountId, sessionId}, done) ->
    query {
      accountId: accountId,
      queries:
        chatPairs:
          ids: sessionId: sessionId
          select:
            isWatching: 'chatSession.relationMeta.isWatching'
            chat: 'chat'
    }, (err, {chatPairs}) ->

      chats = []
      # get info for a specific chat
      rehydrate = (chatPair, cb) ->
        message.timestamp = new Date(parseInt(message.timestamp)) for message in chatPair.chat.history
        chatPair.chat.isWatching = chatPair.isWatching == "true" ? true : false
        chats.push chatPair.chat
        cb()

      async.forEach chatPairs, rehydrate, ->
        done null, chats
