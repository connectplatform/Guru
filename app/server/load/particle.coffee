MongoWatch = require 'mongo-watch'
createServer = config.require 'load/createServer'
db = config.require 'load/mongo'
{Session} = db.models
{Stream} = require 'particle'
watcher = new MongoWatch {format: 'normal'}

port = process.env.GURU_PARTICLE_PORT or config.app.port

unless port is 'DISABLED'
  stream = new Stream
    # onDebug: console.log

    identityLookup: ({sessionSecret}, done) ->
      Session.findOne {secret: sessionSecret}, (err, session) ->
        if session?
          done err, session
        else
          errMsg = 'No Session associated with sessionSecret'
          done errMsg, session

    dataSources: # {}
      # src:
      #   manifest:
      #   payload:
      #   delta:
      sessions:
        manifest:
          username: true
        payload:
          ({sessionSecret}, done) ->
            Session.findOne {sessionSecret}, (err, session) ->
              done err, {data: [session]}
        delta:
          (identity, listener) ->
            watcher.watch "#{config.mongo.dbName}.sessions", listener

    disconnect: ->
      watcher.stopAll()

module.exports =
  stream: stream