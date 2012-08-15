db = require '../../mongo'

module.exports = (res, id, modelName) ->
  Model = db.models[modelName]
  Model.findOne {_id: id}, (err, model) ->
    return res.send err, null if err? or not model?

    model.remove (err) ->
      return res.send err, null if err?
      res.send null, "#{modelName} removed"
