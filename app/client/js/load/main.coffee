define ["load/server", "load/routes", "load/notify"],
  (server, routes, notify) ->
    console.log 'main ran'
    Object.extend()

    server.ready (services) ->
      #server.log 'Vein is ready', {availibleServices: services}
