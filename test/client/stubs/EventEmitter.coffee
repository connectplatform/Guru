define ->

  class EventEmitter

    constructor: ->
      @listeners = {}
      @middleware = []

    on: (event, action) ->
      throw new Error "'#{event}' arg is not a function" if typeof action isnt 'function'
      @listeners[event] ?= []
      @listeners[event].push action

    emit: (event, args...) ->

      # thread args through middleware
      chain = ([first, rest...], args...) ->
        return args unless first?

        # pass filtered args or default args
        next = (filteredArgs...) ->
          filteredArgs = args if filteredArgs.length is 0
          chain rest, filteredArgs...

        return first next, event, args...

      args = chain @middleware, args...

      # call any listeners
      if @listeners[event]?
        for action in @listeners[event]
          action args...

    removeListener: (event, fn) ->
      ftext = fn.toString()
      @listeners[event] =
        @listeners[event]?.filter (fn) -> ftext == fn.toString()

    removeAllListeners: (event) ->
      delete @listeners[event]

    use: (fn) ->
      @middleware.push fn
