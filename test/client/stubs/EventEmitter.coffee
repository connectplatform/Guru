define ->

  class EventEmitter

    constructor: ->
      @listeners = {}
      @middleware = []

    on: (event, action) ->
      @listeners[event] ?= []
      @listeners[event].push action

    emit: (event, args...) ->

      # thread args through middleware
      chain = ([first, rest...], args...) ->
        unless first?
          return args
        next = (args...) -> chain rest, args...
        return first next, event, args...

      args = chain @middleware, args...

      if @listeners[event]?
        for action in @listeners[event]
          action args...

    removeListener: (event, fn) ->
      ftext = fn.toString()
      @listeners[event] =
        @listeners[event].filter (fn) -> ftext == fn.toString()

    removeAllListeners: (event) ->
      @listeners[event] = undefined

    use: (fn) ->
      @middleware.push fn
