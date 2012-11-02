define ["load/server"], (server) ->
  ->
    server.ready ->
      server.setSessionOffline {sessionId: server.cookie('session')}, (err) ->
        server.cookie 'session', null # delete login cookie
        window.location = '/'
