define ["app/server"], (server) ->
  (args, next) ->
    console.log "about to call server.ready"
    server.ready ->
      console.log "called it!"
      next()
###
      server.getMyRole (err, role) ->
        if role isnt "Operator"
          next()
        else
          window.location.hash = "#/dashboard"
          next "redirecting operator to dashboard"
