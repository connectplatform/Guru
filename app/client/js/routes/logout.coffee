define ["load/server", 'app/config'], (server, config) ->
  ->
    server.ready ->
      server.logout (err) ->
        $.cookies.del 'session'
        window.location = '/chat.html'
