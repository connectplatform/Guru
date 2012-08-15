define ["app/server", "app/routes", "app/notify"],
  (server, routes, notify) ->

    server.ready (services) ->
      console.log "Connected - Available services: #{services}"
