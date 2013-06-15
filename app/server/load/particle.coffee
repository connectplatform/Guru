MongoWatch = require 'mongo-watch'
createServer = config.require 'load/createServer'
db = config.require 'load/mongo'
{Chat, ChatSession, Session} = db.models
{Stream} = require 'particle'
watcher = new MongoWatch {format: 'normal'}

port = process.env.GURU_PARTICLE_PORT or config.app.port

module.exports = (server) ->
  unless port is 'DISABLED'
    stream = new Stream
      #onDebug: console.log

      #identityLookup: config.service 'particle/identityLookup'

      identityLookup: (args, done) ->
        config.services['particle/identityLookup'] args, (err, result) ->
          done err, result

      #identityLookup: ({sessionSecret}, done) ->
        #Session.findOne {secret: sessionSecret}, (err, session) ->
          #unless session?
            #done 'Your Session could not be found.'
          #else
            #done err, session

      dataSources:

        # a user's own session data
        mySession:
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
        myChats:
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

        #chatSessions:
          #manifest: true
          #payload:
            #(identity, done) ->
          #delta:
            #(identity, listener) ->
              #watcher.watch "#{config.mongo.dbName}.chatsessions", listener

        #allSessions:
        #allChats:

      disconnect: ->
        watcher.stopAll()

  stream.init(server)
