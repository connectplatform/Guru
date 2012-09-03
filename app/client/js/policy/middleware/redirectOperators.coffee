define ["app/server"], (server) ->
  (args, next) ->
    console.log "args to redirectOperator: ", args
    if args.role is "Operator"
      window.location.hash = "#/dashboard"
      next "redirecting operator to dashboard"
    else
      next null, args
