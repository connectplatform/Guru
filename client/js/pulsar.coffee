define ["app/config", "ext/pulsar"], (config, _) ->
  #TODO change this if pulsar gets updated to play nice with AMD again
  Pulsar.createClient port: config.pulsarPort
