define ["app/server"], (server) ->
  (args, next) ->
    if args.role is 'Visitor'
      window.location.hash = "#/newChat"
      next "redirecting visitor to newChat"
    else
      next null, args
