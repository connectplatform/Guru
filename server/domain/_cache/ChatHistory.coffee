rand = require '../../../lib/rand'

module.exports =
  init: (id) ->
    id ?= rand()
    @key = "chat:#{id}:history"
    return @

  push: (data, next) ->
    @client.rpush @key, JSON.stringify(data), next
    return @

  get: (next) ->
    @client.lrange @key, 0, -1, next
    return @
