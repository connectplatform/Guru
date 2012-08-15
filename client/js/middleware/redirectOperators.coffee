define ["app/server"], (server) ->
  (args, next) ->
    server.ready ->
      server.getMyRole (err, role) ->
        if role isnt "Operator"
          next()
        else
          window.location.hash = "#/dashboard"
          next "redirecting operator to dashboard"
