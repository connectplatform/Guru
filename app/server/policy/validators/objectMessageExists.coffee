module.exports = (args, next) ->
  {message} = args
  return next 'expects message argument' unless message?
  next null, args
