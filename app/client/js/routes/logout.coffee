define ["load/server", 'app/config'], (server, config) ->
  ->
    server.ready ->
      server.logout (err) ->
        server.cookie 'session', null # delete login cookie
        window.location = '/chat.html'
