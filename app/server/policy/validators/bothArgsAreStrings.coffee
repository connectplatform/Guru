{getType} = config.require 'load/util'

module.exports = (args, cookies, cb) ->
  [first, second] = args
  return cb "expected two strings as arguments" unless first? and getType first is 'String'
  return cb "expected two strings as arguments" unless second? and getType second is 'String'
  cb()
