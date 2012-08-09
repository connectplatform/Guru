db = require '../../mongo'

module.exports = (res, fields, modelName) ->
  Model = db.models[modelName]

  {createFields, filterOutput} = require "../_models/#{modelName}Filters"

  getModel = (fields, cb) ->
    if fields.id?
      Model.findOne {_id: fields.id}, (err, foundModel) ->
        return res.send err, null if err?
        cb foundModel
    else
      createdModel = createFields new Model
      cb createdModel

  getModel fields, (foundModel) ->
    foundModel[key] = value for key, value of fields when key isnt 'id'
    foundModel.save (err) ->
      console.log "error saving #{model} model: #{err}" if err?

      res.send err, filterOutput foundModel
