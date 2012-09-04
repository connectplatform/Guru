define ["load/server"], (server) ->
  ->
    server.cookie 'session', null # delete login cookie
    window.location = '/'
