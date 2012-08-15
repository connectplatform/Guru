define ["app/server"], (server) ->
  (args, next) ->
    server.ready ->
      server.getMyRole (err, role) ->
        if role isnt "Visitor"
          next()
        else
          window.location.hash = "#/newChat"
          next "redirecting visitor to newChat"
