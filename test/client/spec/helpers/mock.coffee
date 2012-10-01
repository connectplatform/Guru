define ['load/server', 'load/pulsar', 'policy/registerSessionUpdates', 'templates/sidebar', 'routes/sidebar'],
  (server, pulsar, registerSessionUpdates, sbTemp, sidebar) ->

    mock =
      renderSidebar: ->
        sidebar {role: 'Administrator'}, sbTemp

      loggedIn: ->
        server.cookie 'session', 'session_foo'
        registerSessionUpdates()
        server.getMyRole = (args..., cb) ->
          cb null, 'Operator'

      loggedOut: ->
        server.cookie 'session', null
        server.getMyRole = (args..., cb) ->
          cb null, 'None'

      visitor: ->
        server.cookie 'session', 'session_foo'
        server.getMyRole = (args..., cb) ->
          cb null, 'Visitor'

      services: ->
        server.login = (args..., cb) ->
          mock.loggedIn()
          cb null, {name: 'Bob'}
        server.getMyRole = (args..., cb) ->
          cb null, 'None'
        server.getMyChats = (args..., cb) ->
          cb null, []
        server.getChatStats = (args..., cb) ->
          cb null, {all: [], unanswered: [], invites: [], unreadMessages: {}}
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
        server.getLogoForChat = (args..., cb) ->
          cb null, "http://s3.amazonaws.com/guru-dev/#{encodeURIComponent 'www.example.com'}/logo"
        server.printChat = (args..., cb) ->
          cb null, null
        server.setSessionOffline = (args..., cb) ->
          cb null, null

      activeChats: ->
        server.getActiveChats = (args..., cb) ->
          # this is duplicated in boilerplate for server tests
          # TODO: refactor into general collection of mocks
          now = (new Date).getTime()
          cb null, [
            {
              id: 'chat_3'
              visitor:
                username: 'Ralph'
              status: 'active'
              relation: 'invite'
              creationDate: now
              history: []
            }
            {
              id: 'chat_1'
              visitor:
                username: 'Bob'
              status: 'waiting'
              creationDate: now
              history: []
            }
            {
              id: 'chat_2'
              visitor:
                username: 'Suzie'
              status: 'active'
              creationDate: now
              history: []
            }
            {
              id: 'chat_4'
              visitor:
                username: 'Frank'
              status: 'vacant'
              creationDate: now
              history: []
            }
          ]

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

