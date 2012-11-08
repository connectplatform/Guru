db = config.require 'load/mongo'

module.exports =
  required: ['modelId', 'modelName']
  service: ({modelId, modelName}, done) ->
    Model = db.models[modelName]
    Model.findOne {_id: modelId}, (err, model) ->
      return done err if err or not model?

      model.remove (err) ->
        return done err if err
        return done err, "#{modelName} removed"
