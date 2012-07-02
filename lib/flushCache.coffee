{exec} = require 'child_process'
module.exports = (cb)->
  exec "redis-cli FLUSHALL", cb