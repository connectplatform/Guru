cookies = {}

define [], ->
  addServices: (services) ->
    for serviceName, serviceDef of services
      @addService serviceName, serviceDef
    
  addService: (serviceName, serviceDef) ->
    #Service signature validation
    this[serviceName] = (params, done) ->
      unless typeof params is 'object' and typeof done is 'function'
        console.log 'params: ', params
        return done 'Unexpected Argument Format'
      serviceDef params, done

  ready: (fn) -> fn()
  cookie: (key, val) ->
    if val?
      cookies[key] = val
    else
      return cookies[key]
