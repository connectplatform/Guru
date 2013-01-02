define ["app/config", "vendor/pulsar"], (config, _) ->
  #TODO change this if pulsar gets updated to play nice with AMD again
  pulsar = Pulsar.createClient port: config.pulsarPort
  window.pulsar = pulsar
  return pulsar
