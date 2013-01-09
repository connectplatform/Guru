module.exports = (args, next) ->
  message = args?.message
  return next 'expects message argument' unless message?
  next null, args
