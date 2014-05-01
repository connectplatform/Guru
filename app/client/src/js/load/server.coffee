define ["app/config", "helpers/handleError", "vein/vein"], (config, handleError, Vein) ->
  #TODO change this if vein gets updated to play nice with AMD again
  vein = Vein
  server = vein.createClient {port: config.port, host: config.api}

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
          # console.log "calling '#{serviceName}' with:", args
          serviceDef args, (err, results) ->
            # console.log "#{serviceName}:", {err, results}
            # global error handling for server responses
            handleError err, results

            done err, results

  return wrapped
