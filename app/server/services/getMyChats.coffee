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
            chat: 'chat'
            isWatching: 'chatSession.relationMeta.isWatching'
    }, (err, {chatPairs}) ->

      chats = []
      # get info for a specific chat
      for chatPair in chatPairs
        chatPair.chat.isWatching = chatPair.isWatching
        chats.push chatPair.chat

      done null, chats
