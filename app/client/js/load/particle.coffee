# cache the models
models = null

define ['vendor/particle', 'app/config'], ({Collector}, config) ->

  # watch out, this will not change the model if you pass a different identity
  (identity) ->

    # return cached version if it exists
    if models?
      return models

    # otherwise initialize a new Collector
    else
      models = new particle.Collector
        # onDebug: console.log
        network:
          host: config.api
          port: config.particlePort
        identity: identity

      window.models = models
      return models
