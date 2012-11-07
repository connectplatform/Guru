# This should really be called 'isValidCrudModel' or something like that.
# ...or it should be based off existance of db.models[modelName]

module.exports = (args, next) ->
  modelName = args?.modelName
  return next "expected model name" unless modelName?

  return next "invalid model name" unless modelName in ["User", "Specialty", "Website"]
  next null, args
