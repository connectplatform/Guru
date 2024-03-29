cookies = {}

define [], ->
  addServices: (services) ->
    for serviceName, serviceDef of services
      @addService serviceName, serviceDef

  addService: (serviceName, serviceDef) ->
    #Service signature validation
    this[serviceName] = (params, done) ->
      done ||= (err) ->
        throw new Error err if err
      unless typeof params is 'object' and typeof done is 'function'
        console.log "Service [#{serviceName}] got invalid params: ", params
        return done "Unexpected Argument Format in #{serviceName}"
      serviceDef params, done

  ready: (fn) -> fn()
  cookie: (key, val) ->
    if val?
      cookies[key] = val
    else
      return cookies[key]
