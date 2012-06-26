define ["app/server", "app/notify"], (server, notify) ->
  (args, templ) ->

    if (server.cookie 'login')?
      window.location.hash = '#/dashboard'
    else
      window.location.hash = '#/login'
