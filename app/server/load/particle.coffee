{Stream} = require 'particle'
logger = config.require 'lib/logger'

module.exports = (server) ->
  stream = new Stream
    #onDebug: logger.grey

    identityLookup: config.service 'particle/identityLookup'

    dataSources:

      # a user's own session data
      mySession:
        manifest: true

        payload: config.service 'particle/mySessionPayload'
        delta: config.service 'particle/mySessionDelta'

      # a user's own chats
      myChats:
        manifest:
          history: true

        payload: config.service 'particle/myChatsPayload'
        delta: config.service 'particle/myChatsDelta'

      #visibleChatSessions:
        #manifest: true
        #payload:
          #(identity, done) ->
        #delta:
          #(identity, listener) ->
            #watcher.watch "#{config.mongo.dbName}.chatsessions", listener

      #visibleSessions:
      #visibleChats:

    disconnect: ->
      watcher.stopAll()

  stream.init(server)
