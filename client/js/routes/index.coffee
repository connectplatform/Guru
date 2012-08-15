define ["app/server", "app/notify"], (server, notify) ->
  (args, templ) ->

    server.ready ->
      server.getMyRole (err, role) ->
        if (role is 'Operator') or (role is 'Administrator')
          window.location.hash = '/dashboard'
        else
          window.location.hash = '/login'
