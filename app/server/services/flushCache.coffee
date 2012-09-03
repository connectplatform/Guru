{exec} = require 'child_process'
module.exports = (cb) ->
  unless process.env.NODE_ENV is 'production'
    exec "redis-cli FLUSHALL", cb
  else
    cb()
