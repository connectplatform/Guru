# cache the models
models = null

define ['vendor/particle', 'app/config'], ({Collector}, config) ->

  # watch out, this will not change the model if you pass a different identity
  init: (identity, done) ->

    # return cached version if it exists
    if models?
      return done null, models

    # otherwise initialize a new Collector
    else
      models = new Collector
        # onDebug: console.log
        network:
          host: config.api
          port: config.particlePort
        identity: identity

      window.models = models
      models.register (err) ->
        return done err if err
        models.ready ->
          done null, models

  getModels: ->
    return models
