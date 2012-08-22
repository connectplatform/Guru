{getType} = require '../../../lib/util'
module.exports = (args, cookies, cb) ->
  [first, second] = args
  return cb "expected two strings as arguments" unless first? and getType first is '[object String]'
  return cb "expected two strings as arguments" unless second? and getType second is '[object String]'
  cb()
