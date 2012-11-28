define ['load/server', 'load/pulsar', 'policy/registerSessionUpdates', 'templates/sidebar', 'routes/sidebar'],
  (server, pulsar, registerSessionUpdates, sbTemp, sidebar) ->

    mock =
      renderSidebar: ->
        sidebar {role: 'Supervisor'}, sbTemp

      loggedIn: (role = 'Operator') ->
        server.cookie 'session', 'session_foo'
        registerSessionUpdates()
        server.getMyRole = (params, cb) ->
          cb null, role

      loggedOut: ->
        server.cookie 'session', null
        server.getMyRole = (params, cb) ->
          cb null, 'None'

      visitor: ->
        server.cookie 'session', 'session_foo'
        server.getMyRole = (params, cb) ->
          cb null, 'Visitor'

      services: ->
        server.addServices
          login: (params, cb) ->
            mock.loggedIn()
            cb null, {firstName: 'Bob'} #short version of the user object
          leaveChat: ({chatId}, cb) ->
            pulsar.channel(chatId).emit 'serverMessage',
              type: 'notification'
              message:'Visitor has left the chat'
              timestamp: 777
            cb null, 'foo'
          awsUpload: (params, cb) ->
            cb null, 'foo'
          getMyRole: (params, cb) ->
            cb null, 'None'
          getMyChats: (params, cb) ->
            cb null, []
          getRecurlyToken: (params, cb) ->
            cb null, {token: 'foo'}
          getChatStats: (params, cb) ->
            cb null, {all: [], unanswered: [], invites: [], unreadMessages: {}}
          getActiveChats: (params, cb) ->
            cb null, []
          getExistingChat: (params, cb) ->
            cb null, null
          createAccount: (params, cb) ->
            cb null, {accountId: 'account_foo', userId: 'owner_bar'}
          createChatOrGetForm: (params, cb) ->
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
          newChat: (params, cb) ->
            cb null, {chatId: 'foo'}
          visitorCanAccessChannel: (params, cb) ->
            cb null, 'true'
          getChatHistory: (params, cb) ->
            cb null,
            [
              {
                timestamp: 0,
                type: "notification",
                message: 'Welcome to live chat! An operator will be with you shortly.'
              }
            ]
          getLogoForChat: (params, cb) ->
            cb null, "http://s3.amazonaws.com/guru-dev/website/#{encodeURIComponent 'foo.com'}/logo"
          printChat: (params, cb) ->
            cb null, null
          setSessionOffline: (params, cb) ->
            cb null, null
          findModel: ({modelName}, cb) ->
            switch modelName
              when 'Specialty'
                record = [
                  {
                    accountId: '123'
                    id: '123abc'
                    name: 'Sales'
                  }
                  {
                    accountId: '123'
                    id: '123abc'
                    name: 'Billing'
                  }
                ]

              when 'Account'
                record = [{accountType: 'Unlimited'}]

              when 'Website'
                record = [
                  _id: '123'
                  id: '123'
                  url: 'foo.com'
                  specialties: ['Sales']
                  contactEmail: 'owner@foo.com'
                ]
              when 'User'
                record = [{_id: 123, firstName: 'Bob', role: 'Visitor'}]
              else
                record = [{id: 'Make a new model mock'}]
                console.log record
            cb null, record
          deleteModel: (params, cb) ->
            cb null, params
          log: (params, cb) ->
            console.log 'log:', params.message
            console.log params
            cb null, null
          saveModel: ({fields, modelName, sessionId, accountId}, cb) ->
            savedModel = fields
            cb null, fields

      returnChat: ->
        server.createChatOrGetForm = ({websiteUrl, department, username}, cb) ->
          expect(websiteUrl).toBeDefined 'Missing websiteUrl.'
          expect(department).toBeDefined 'Missing department.'
          expect(username).toBeDefined 'Missing username.'
          cb null, chatId: 'chat_foo'

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
              websiteUrl: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_1'
              visitor:
                username: 'Bob'
              status: 'waiting'
              creationDate: now
              history: []
              websiteUrl: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_2'
              visitor:
                username: 'Suzie'
              status: 'active'
              creationDate: now
              history: []
              websiteUrl: 'foo.com'
              department: 'Sales'
            }
            {
              id: 'chat_4'
              visitor:
                username: 'Frank'
              status: 'vacant'
              creationDate: now
              history: []
              websiteUrl: 'foo.com'
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

