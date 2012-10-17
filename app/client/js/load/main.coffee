define ["load/server", "load/routes", "load/notify"],
  (server, routes, notify) ->
    Object.extend()

    server.ready (services) ->
      server.log 'Vein is ready', {availibleServices: services}
