define ["app/config", "vendor/vein"], (config, _) ->
  #TODO change this if vein gets updated to play nice with AMD again
  server = Vein.createClient(port: config.port)

  wrapped = {}
  utility = ['disconnect', 'cookie', 'ready']

  # bind utility functions
  for serviceName, serviceDef of server when serviceName in utility
    wrapped[serviceName] = serviceDef.bind server

  # proxy services, merging any local data (e.g. sessionId)
  server.ready ->
    for serviceName, serviceDef of server when serviceName not in utility
      do (serviceName, serviceDef) ->
        wrapped[serviceName] = (args..., done) ->

          # fanagle args
          if (typeof done) isnt 'function'
            args.push done if done
            done = ->
          args = args[0] || {}

          # merge session cookie
          args['sessionId'] = $.cookies.get 'session'

          # activate service
          #console.log "calling '#{serviceName}' with:", args
          serviceDef args, (err, results...) ->
            console.log 'service error:', err if err
            done err, results...

  return wrapped
