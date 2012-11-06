cookies = {}

define [], ->
  addService: (serviceName, params, done) ->
    this[serviceName] = (params, done) ->
      return done "Unexpect Argument Format" unless typeof params is 'object' and typeof done is 'function'
      serviceDef params, done

  ready: (fn) -> fn()
  cookie: (key, val) ->
    if val?
      cookies[key] = val
    else
      return cookies[key]
