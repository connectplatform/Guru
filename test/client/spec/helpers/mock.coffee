define ['app/server', 'app/pulsar', 'app/registerSessionUpdates'],
  (server, pulsar, registerSessionUpdates) ->

    mock =
      loggedIn: ->
        server.cookie 'session', 'session_foo'
        registerSessionUpdates()
        server.getMyRole = (args..., cb) ->
          cb null, 'Operator'

      loggedOut: ->
        server.cookie 'session', null
        server.getMyRole = (args..., cb) ->
          cb null, 'None'

      services: ->
        server.login = (args..., cb) ->
          mock.loggedIn()
          cb null, {name: 'Bob'}
        server.getMyRole = (args..., cb) ->
          cb null, 'None'
        server.getMyChats = (args..., cb) ->
          cb null, []
        server.getChatStats = (args..., cb) ->
          cb null, {unanswered: 0}
        server.getActiveChats = (args..., cb) ->
          cb null, []
        server.getExistingChatChannel = (args..., cb) ->
          cb null, null
        server.newChat = (args..., cb) ->
          cb null, {chatId: 'foo'}
        server.visitorCanAccessChannel = (args..., cb) ->
          cb null, 'true'
        server.getChatHistory = (args..., cb) ->
          cb null, []

      hasChats: ->
        server.getMyChats = (args..., cb) ->

          history =
            message: 'hello'
            username: 'Bob'
            timestamp: new Date

          chat = (id, name) ->
            id: id
            visitor:
              department: null
              website: null
              username: name
            isWatching: false
            status: 'active'
            creationDate: new Date
            history: [
              history
            ]

          cb null, [chat('chat_1', 'Bob'), chat('chat_2', 'Sam')]

