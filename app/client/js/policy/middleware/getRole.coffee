define ["load/server"], (server) ->
  (args, next) ->
    console.log 'args:', args
    server.ready ->
      server.getMyRole {}, (err, role) ->
        next null, args.merge {role: role}
