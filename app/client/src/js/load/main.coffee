# this should get run before we load anything else
Object.extend()

define ["load/server", "load/routes", "load/notify"],
  (server, routes, notify) ->
    server.ready (services) ->
      #server.log {message: 'Vein is ready', context: {availibleServices: services}}
