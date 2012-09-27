module.exports = (args, cookies, cb) ->
  message = args?.message
  return cb 'expects message argument' unless message?
