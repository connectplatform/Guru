define ["load/server"], (server) ->
  ->
    server.ready ->
      server.setSessionOffline server.cookie('session'), (err) ->
        server.cookie 'session', null # delete login cookie
        window.location = '/'
