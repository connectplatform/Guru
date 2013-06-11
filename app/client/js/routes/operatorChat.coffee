define ["load/server", "load/notify", 'components/operatorChat', 'vendor/EventEmitter2'],
  (server, notify, operatorChat, EventEmitter2) ->
    routeEvents = new EventEmitter2()

    setup:
      (args, templ, query) ->
        operatorChat.attachTo '#content', {routeEvents: routeEvents}

    teardown:
      (cb) ->
        routeEvents.emit 'teardown'
        cb()
