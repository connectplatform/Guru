db = require '../../mongo'

module.exports = (res, id, modelName) ->
  Model = db.models[modelName]
  Model.findOne {_id: id}, (err, model) ->
    return res.reply err if err? or not model?

    model.remove (err) ->
      return res.reply err if err?
      return res.reply err, "#{modelName} removed"
