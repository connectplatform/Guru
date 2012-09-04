define ["app/config", "vendor/vein"], (config, _) ->
  #TODO change this if vein gets updated to play nice with AMD again
  Vein.createClient(port: config.port)
