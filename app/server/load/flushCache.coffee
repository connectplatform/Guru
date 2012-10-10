async = require 'async'
stoic = require 'stoic'

module.exports = (flushDb, finalDb, cb) ->
  return cb() unless config.env is 'development'
  redis = stoic.client

  deleteKey = (key, cb) ->
    redis.del key, cb

  redis.select flushDb, ->
    redis.keys '*', (err, keys) ->
      async.forEach keys, deleteKey, ->
        redis.select finalDb, cb
