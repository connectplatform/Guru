{getType} = config.require 'load/util'

module.exports = (args, cookies, cb) ->
  [input] = args
  return cb "expected object as first argument" unless input? and getType input is 'Object'
  cb()
