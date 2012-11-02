define ['load/server', 'load/pulsar', 'policy/registerSessionUpdates', 'templates/sidebar', 'routes/sidebar'],
  (server, pulsar, registerSessionUpdates, sbTemp, sidebar) ->

    mock =
      renderSidebar: ->
        sidebar {role: 'Supervisor'}, sbTemp

      loggedIn: ->
        server.cookie 'session', 'session_foo'
        registerSessionUpdates()
        server.getMyRole = (params, cb) ->
          cb null, 'Operator'

      loggedOut: ->
        server.cookie 'session', null
        server.getMyRole = (params, cb) ->
          cb null, 'None'

      visitor: ->
        server.cookie 'session', 'session_foo'
        server.getMyRole = (params, cb) ->
          cb null, 'Visitor'

      services: ->
        server.login = (params, cb) ->
          mock.loggedIn()
          cb null, {firstName: 'Bob'} #short version of the user object
        server.leaveChat = (params, cb) ->
          cb null, 'foo'
        server.getMyRole = (params, cb) ->
          cb null, 'None'
        server.getMyChats = (params, cb) ->
          cb null, []
        server.getChatStats = (params, cb) ->
          cb null, {all: [], unanswered: [], invites: [], unreadMessages: {}}
        server.getActiveChats = (params, cb) ->
          cb null, []
        server.getExistingChat = (params, cb) ->
          cb null, null
        server.createChatOrGetForm = (params, cb) ->
          cb null, fields: [
                name: 'username'
                inputType: 'text'
                default: 'Chat Name'
                label: 'Chat Name'
              ,
                name: 'department'
                inputType: 'selection'
                selections: ['Sales', 'Billing']
                label: 'Department'
            ]
        server.newChat = (params, cb) ->
          cb null, {chatId: 'foo'}
        server.visitorCanAccessChannel = (params, cb) ->
          cb null, 'true'
        server.getChatHistory = (params, cb) ->
          cb null, []
        server.getLogoForChat = (params, cb) ->
          cb null, "http://s3.amazonaws.com/guru-dev/#{encodeURIComponent 'foo.com'}/logo"
        server.printChat = (params, cb) ->
          cb null, null
        server.serverLog = (params, cb) ->
          cb null, 'Success'
        server.log = (params) ->
        server.setSessionOffline = (params, cb) ->
          cb null, null

      returnChat: ->
        server.createChatOrGetForm = ({websiteUrl, department, username}, cb) ->
          expect(websiteUrl).toBeDefined 'Missing websiteUrl.'
          expect(department).toBeDefined 'Missing department.'
          expect(username).toBeDefined 'Missing username.'
          cb null, chatId: 'foo'

      noOperators: ->
        server.createChatOrGetForm = (params, cb) ->
          cb null, noOperators: true

      activeChats: ->
        server.getActiveChats = (params, cb) ->
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
              website: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_1'
              visitor:
                username: 'Bob'
              status: 'waiting'
              creationDate: now
              history: []
              website: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_2'
              visitor:
                username: 'Suzie'
              status: 'active'
              creationDate: now
              history: []
              website: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_4'
              visitor:
                username: 'Frank'
              status: 'vacant'
              creationDate: now
              history: []
              website: 'foo.com'
              department: 'Sales'
            }
          ]

      hasChats: ->
        server.getMyChats = (params, cb) ->

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

