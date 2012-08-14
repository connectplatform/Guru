define ['app/server', 'app/pulsar'], (server, pulsar) ->

  mock =
    loggedIn: ->
      server.cookie 'session', 'session_foo'

    loggedOut: ->
      server.cookie 'session', null

    services: ->
      server.login = (args..., cb) ->
        mock.loggedIn()
        cb null, {name: 'Bob'}
      server.getMyRole = (args..., cb) ->
        cb null, 'Operator'
      server.getMyChats = (args..., cb) ->
        cb null, []
      server.getChatStats = (args..., cb) ->
        cb null, {unanswered: 0}
      server.getActiveChats = (args..., cb) ->
        cb null, []

    hasChats: ->
      server.getActiveChats = (args..., cb) ->

        history =
          message: 'hello'
          username: 'Bob'
          timestamp: new Date

        chat =
          visitor: ''
          status: ''
          creationDate: new Date
          history: [
            JSON.stringify history
          ]

        cb null, [chat]

