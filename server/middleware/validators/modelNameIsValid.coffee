module.exports = (args, cookies, cb) ->
  [_, modelName] = args
  return cb "expected model name as second argument" unless modelName?

  return cb "invalid model name" unless (modelName is "User") or (modelName is "Specialty") or (modelName is "Website")
  cb()
