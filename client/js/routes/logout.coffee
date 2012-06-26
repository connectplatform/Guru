define ["guru/server"], (server) ->
  ->
    server.cookie 'login', null # delete login cookie
    window.location = '/'
