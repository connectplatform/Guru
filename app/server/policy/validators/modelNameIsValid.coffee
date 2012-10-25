# This should really be called 'isValidCrudModel' or something like that.
# ...or it should be based off existance of db.models[modelName]

module.exports = (args, next) ->
  modelName = args?.modelName
  return cb "expected model name as second argument" unless modelName?

  return cb "invalid model name" unless modelName in ["User", "Specialty", "Website"]
  cb()
