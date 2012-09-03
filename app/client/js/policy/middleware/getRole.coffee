define ["app/server"], (server) ->
  (args, next) ->
    server.ready ->
      server.getMyRole (err, role) ->
        next null, args.merge {role: role}
