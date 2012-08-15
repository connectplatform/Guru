define ["app/server"], (server) ->
  ({role}, next) ->
    if role is 'None'
      window.location.hash = "#/login"
      next "redirecting guest to login"

    else next()
