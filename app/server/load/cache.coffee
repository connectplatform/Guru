cache = {}
retainFor = config?.cache?.retainFor || 300000

module.exports =
  store: (resource, data) ->
    #config.log new Error "storing #{resource} with: #{data}" if resource.match /hasImage/
    #console.log "storing at #{resource}:", data
    cache[resource] =
      timestamp: Date.now()
      data: data

  retrieve: (resource) ->
    if cache[resource] and (cache[resource].timestamp + retainFor) > Date.now()
      # console.log 'retrieving from cache'.yellow
      cache[resource].data
    else
      undefined

  erase: (resource) ->
    delete cache[resource]
