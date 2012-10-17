define ["app/config", "vendor/vein"], (config, _) ->
  #TODO change this if vein gets updated to play nice with AMD again
  server = Vein.createClient(port: config.port)
  server.log = (message, object) ->
    server.serverLog message, object, ->
  return server
