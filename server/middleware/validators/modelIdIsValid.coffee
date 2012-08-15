module.exports = (args, cookies, cb) ->
  [id] = args
  return cb "expected model id as first argument" unless id
  cb()
