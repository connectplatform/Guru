define ["app/server"], (server) ->
  ({role}, next) ->
    if role is 'Visitor'
      window.location.hash = "#/newChat"
      next "redirecting visitor to newChat"

    else next()
