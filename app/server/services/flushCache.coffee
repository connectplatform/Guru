async = require 'async'
stoic = require 'stoic'

module.exports = (flushDb, finalDb, cb) ->
  return cb() unless process.env.NODE_ENV is 'development'
  redis = stoic.client
  console.log 'stoic: ', stoic

  deleteKey = (key, cb) ->
    redis.del key, cb

  redis.select flushDb, ->
    redis.keys '*', (err, keys) ->
      async.forEach keys, deleteKey, ->
        redis.select finalDb, cb
