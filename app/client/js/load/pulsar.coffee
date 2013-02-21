define ["app/config", "vendor/pulsar"], (config, Pulsar) ->
  pulsar = Pulsar.createClient {port: config.pulsarPort, host: config.api}
  window.pulsar = pulsar
  return pulsar
