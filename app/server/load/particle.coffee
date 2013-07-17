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

      visibleSessions:
        manifest:
          accountId: true
          userId: true
          username: true

        payload: config.service 'particle/visibleSessionsPayload'
        delta: config.service 'particle/visibleSessionsDelta'

      #visibleChatSessions:
        #manifest: true

        #payload: config.service 'particle/visibleChatsSessionsPayload'
        #delta: config.service 'particle/visibleChatsSessionsDelta'

      #visibleChats:
        #manifest: true

        #payload: config.service 'particle/visibleChatsPayload'
        #delta: config.service 'particle/visibleChatsDelta'

    disconnect: ->
      watcher.stopAll()

  stream.init(server)
