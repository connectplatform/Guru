{inspect} = require 'util'
cache = {}
retainFor = config?.cache?.retainFor || 300000

module.exports =
  store: (resource, data) ->
    #console.log "storing at #{resource}:", data
    cache[resource] =
      timestamp: Date.now()
      data: data

  retrieve: (resource) ->
    #console.log 'cache:', Object.keys cache
    if cache[resource] and (cache[resource].timestamp + retainFor) > Date.now()
      #console.log 'used cache!'
      cache[resource].data
    else
      undefined

  erase: (resource) ->
    delete cache[resource]
