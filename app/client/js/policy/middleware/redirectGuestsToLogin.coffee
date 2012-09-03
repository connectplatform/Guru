define ["app/server"], (server) ->
  (args, next) ->
    if args.role is 'None'
      window.location.hash = "#/login"
      next "redirecting guest to login"

    else
      next null, args
