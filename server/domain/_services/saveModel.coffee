db = require '../../mongo'

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

  {createFields, filterOutput} = require "../_models/#{modelName}Filters"

  getModel = (fields, cb) ->
    if fields.id?
      Model.findOne {_id: fields.id}, (err, foundModel) ->
        cb err, foundModel
    else
      createdModel = createFields new Model
      cb null, createdModel

  getModel fields, (err, foundModel) ->
    return res.reply err, null if err?
    foundModel[key] = value for key, value of fields when key isnt 'id'
    foundModel.save (err) ->

      res.reply parseMongooseError(err), filterOutput foundModel
