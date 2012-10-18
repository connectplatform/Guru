db = config.require 'load/mongo'

parseMongooseError = (err) ->
  return null unless err?
  message = ""
  if err?.errors
    for field, info of err.errors
      message += "#{info.message}\n"
    return message
  else
    return "Model error"

module.exports = (res, fields, modelName) ->
  Model = db.models[modelName]

  {createFields, filterOutput} = config.require "models/#{modelName}Filters"

  # get or create
  getModel = (fields, cb) ->
    if fields.id?
      Model.findOne {_id: fields.id}, (err, foundModel) ->
        cb err, foundModel
    else
      cb null, createFields new Model

  # update field data
  getModel fields, (err, foundModel) ->
    return res.reply err, null if err?
    config.log.warn 'Could not find model in saveModel', {fields: fields} unless foundModel
    foundModel[key] = value for key, value of fields when key isnt 'id'
    foundModel.save (err, savedModel) ->
      savedModel = filterOutput savedModel unless err?
      res.reply parseMongooseError(err), savedModel
