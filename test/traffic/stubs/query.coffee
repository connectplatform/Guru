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
            @execute query

      return @

    execute: (query) ->
      # get the data needed for update events
      data = @queries[query].get @collector

      # emit the query event for subscribers
      @emit query, data

    init: (query, updater) ->
      # set up listener to update on query events
      @on query, updater

      # fire initial setup
      @collector.ready () =>
        @execute query


  return {
    config
    QueryProxy
  }