MongoWatch = require 'mongo-watch'
createServer = config.require 'load/createServer'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models
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

    dataSources:

      # a user's own session data
      sessions:
        manifest: true

        # TODO: move payload and delta into services
        payload:
          (identity, done) ->
            {sessionSecret} = identity
            Session.findOne {secret: sessionSecret}, (err, session) ->
              done err, {data: [session]}
        delta:
          (identity, listener) ->
            watcher.watch "#{config.mongo.dbName}.sessions", listener

      # a user's own chats
      chats:
        manifest: true

        # TODO: move payload and delta into services
        payload:
          (identity, done) ->
            {sessionSecret} = identity
            Session.findOne {secret: sessionSecret}, (err, session) ->
              ChatSession.find {sessionId: session._id}, (err, chatSessions) ->
                chatIds = (cs.chatId for cs in chatSessions)
                Chat.find {_id: {'$in': chatIds}}, (err, chats) ->
                  done err, {data: chats}
        delta:
          (identity, listener) ->
            watcher.watch "#{config.mongo.dbName}.chats", listener

    disconnect: ->
      watcher.stopAll()

module.exports =
  stream: stream
