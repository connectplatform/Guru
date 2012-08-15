define ["app/server"], (server) ->
  ({role}, next) ->
    if role is "Operator"
      window.location.hash = "#/dashboard"
      next "redirecting operator to dashboard"

    else
      next()
