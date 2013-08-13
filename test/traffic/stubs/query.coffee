define ['vendor/eventemitter2', 'load/render'], (EventEmitter2, render) ->

  config =
    'unansweredChats':
      path: 'mySession.unansweredChats'

      get: (coll) ->
        {unansweredChats} = coll.data.mySession?[0]
        return {unansweredChats}

    'unreadMessages':
      path: 'mySession.unreadMessages'

      get: (coll) ->
        {unreadMessages} = coll.data.mySession?[0]
        return {unreadMessages}

    'username':
      path: 'mySession.username'

      get: (coll) ->
        {username} = coll.data.mySession?[0]
        return {username}


  class QueryProxy extends EventEmitter2
    constructor: (@collector, config) ->
      @queries = config

      # given a query event and its path, data getter
      for query, def of @queries
        do (query, def) =>

          # when the collector emits a change in <path>
          @collector.on def.path, () =>

            # emit the query event for subscribers
            @emit query, (@dataFor query)

      return @

    dataFor: (query) ->
      # get the data needed for update events
      data = @queries[query].get @collector

    attach: (query, updater) ->
      @collector.ready () =>
        # set up listener to update on query events
        @on query, updater

        # directly update right now, without extra event emitting
        updater (@dataFor query)


  return {
    config
    QueryProxy
  }