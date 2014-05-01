define ["load/server"], (server) ->
  (args, next) ->
    if not args.role or args.role is 'None'
      window.location.hash = "#/login"
      next "redirecting guest to login"

    else
      next null, args
