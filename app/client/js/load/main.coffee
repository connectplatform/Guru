define ["load/server", "load/routes", "load/notify"],
  (server, routes, notify) ->
    Object.extend()

    server.ready (services) ->
      console.log "Connected - Available services: #{services}"
