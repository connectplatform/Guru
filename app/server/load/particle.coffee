{Stream} = require 'particle'
logger = require 'torch'
MongoWatch = require 'mongo-watch'
watcher = new MongoWatch {db: config.mongo.dbName, format: 'normal'}

module.exports = (server) ->
  stream = new Stream

    adapter: watcher
    #onDebug: logger.grey

    # Static lookup, performed once upon registration.
    identityLookup: config.services['particle/identityLookup']

    # Keeping this static maintains the current ability to use it as a
    # security authorization, and avoids complexities associated with
    # mapping multiple lookups onto the identity.
    #
    # We may in the future encounter a use case where the identity has
    # to be dynamic.  We will re-evaluate our options at that point.

    # Relationships Cache
    cacheConfig:
      chatsessions:
        sessionId: 'sessions._id'
        chatId: 'chats._id'

    # 1) create a MW query for chatsessions
    # 2) store the sessionId -> chatId relationship with 'relation' meta
    # update storage on change
    # emit event on change

    dataSources:

      # a user's own session data
      mySession:
        collection: 'sessions'
        criteria: {_id: '@session._id'}
        manifest: true

      # 1) convert '@sessionId' to identity.sessionId
      # when identity.sessionId changes, update query
      #
      # on register:
      #   1) pass the query to MW
      #   2) pipe stream to receiver

      visibleSessions:
        collection: 'sessions'
        criteria: {'accountId': '@session.accountId'}
        manifest:
          accountId: true
          userId: true
          username: true

      visibleChats:
        collection: 'chats'
        criteria: {'accountId': '@session.accountId'}
        manifest:
          accountId: true
          creationDate: true
          status: true
          specialtyId: true
          websiteId: true
          websiteUrl: true

      visibleChatSessions:
        collection: 'chatsessions'
        criteria:
          'accountId': '@session.accountId',
          '$or': {'sessionId': '@session._id', 'relation': {$ne: 'watching'}}
        manifest: true

      myChats:
        collection: 'chats'
        criteria: {'_id': '@session._id|sessions._id>chatsessions._id>chats._id'}
        manifest:
          history: true

      # 1) convert sessionId to a list of chatIds based on relation cache
      # 2) when sessionId or relation changes, update query

  global.appStream = stream # TODO: remove this test code!
  stream.init(server)
