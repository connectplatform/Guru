define ["load/server"], (server) ->
  (args, next) ->
    if args.role is "Operator"
      window.location.hash = "#/dashboard"
      next "redirecting operator to dashboard"
    else
      next null, args
