module.exports = (args, cookies, cb) ->
  message = args?[0]?.message
  return cb 'expects message argument' unless message?
  cb()
