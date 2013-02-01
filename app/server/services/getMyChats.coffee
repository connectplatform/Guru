async = require 'async'
stoic = require 'stoic'
{ChatSession, Chat} = stoic.models
query = config.require 'services/queries/query'
{reject} = config.require 'load/util'

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

      # get info for a specific chat
      chats = for chatPair in chatPairs
        chatPair.chat.isWatching = chatPair.isWatching
        if chatPair.chat?.visitor?.referrerData
          filtered = reject chatPair.chat.visitor.referrerData, 'sessionId', 'specialtyId', 'accountId'
          chatPair.chat.visitor.referrerData = filtered
        chatPair.chat

      done null, {chats: chats}
