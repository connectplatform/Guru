particle = require 'particle'
createServer = config.require 'load/createServer'
db = config.require 'load/mongo'
{Session} = db.models

port = process.env.GURU_PARTICLE_PORT or config.app.port

unless port is 'DISABLED'
  stream = new particle.Stream
    # onDebug: console.log

    identityLookup: ({sessionSecret}, done) ->
      Session.findOne {secret: sessionSecret}, (err, session) ->
        if session?
          done err, session
        else
          errMsg = 'No Session associated with sessionSecret'
          done errMsg, session

    dataSources: {}
      # src:
      #   manifest:
      #   payload:
      #   delta:
      # session:
      #   manifest:
      #     username: true
      #   payload:
      #     ({sessionSecret}, done) ->
      #       Session.findOne {sessionSecret}, (err, session) ->
      #         done err, {username: username}
      #   delta: null

    disconnect: -> null
      # config.watcher.stopAll()

module.exports =
  stream: stream