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


  class QueryProxy extends EventEmitter2
    constructor: (@collector, config) ->

      # for each data model path
      for event, def of config
        do (event, def) =>

          # when the collector emits a change in <path>
          @collector.on def.path, () =>

            # get the data needed for update events
            data = def.get @collector

            # emit the event for subscribers
            @emit event, data

      return @


  return {
    config
    QueryProxy
  }