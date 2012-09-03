define ["app/server", "app/routes", "app/notify"],
  (server, routes, notify) ->
    Object.extend()

    server.ready (services) ->
      console.log "Connected - Available services: #{services}"
