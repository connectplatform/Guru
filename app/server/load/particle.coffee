particle = require 'particle'
createServer = config.require 'load/createServer'

port = process.env.GURU_PARTICLE_PORT or config.app.port

unless port is 'DISABLED'
  stream = new particle.Stream
    # onDebug: console.log

    identityLookup: (sessionId, done) ->
      done null, {}

    dataSources: {}
      # src:
      #   manifest:
      #   payload:
      #   delta:

    disconnect: -> null
      # config.watcher.stopAll()

module.exports =
  stream: stream