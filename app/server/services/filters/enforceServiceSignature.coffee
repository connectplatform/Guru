module.exports = (args, next) ->
  return next "Invalid signature: expected object as first arg" unless typeof args is 'object'
  next()
