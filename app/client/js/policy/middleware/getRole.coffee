define ["load/server"], (server) ->
  (args, next) ->
    server.ready ->
      server.getMyRole {}, (err, params) ->
        next null, args.merge params
