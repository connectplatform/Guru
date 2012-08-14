define ['app/server', 'app/pulsar'], (server, pulsar) ->

  console.log 'mocking you'

  cookie: ->
    server.cookie 'session', 'session_foo'

  removeCookie: ->
    server.cookie 'session', null

  services: ->
    server.login = (args..., cb) ->
      cb null, {name: 'Bob'}
    server.getMyRole = (args..., cb) ->
      cb null, 'Operator'
    server.getChatStats = (args..., cb) ->
      cb null, {unanswered: 0}
    server.getActiveChats = (args..., cb) ->
      cb null, []
