define ["guru/server", "guru/routes", "guru/notify"], (server, routes, notify) ->

  server.ready (services) ->
    console.log "Connected - Available services: #{services}"

  #server.close (reason='Reload to re-establish') ->
  #  notify.error "Connection lost: #{reason}"