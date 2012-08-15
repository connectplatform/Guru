define ->

  class EventEmitter

    constructor: ->
      @listeners = {}

    on: (event, action) ->
      @listeners[event] ?= []
      @listeners[event].push action

    emit: (event, args...) ->
      if @listeners[event]?
        for action in @listeners[event]
          action args...

    removeListener: (event, fn) ->
      ftext = fn.toString()
      @listeners[event] =
        @listeners[event].filter (fn) -> ftext == fn.toString()

    removeAllListeners: (event) ->
      @listeners[event] = undefined
