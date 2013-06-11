db = config.require 'load/mongo'

module.exports =
  required: ['accountId', 'modelId', 'modelName']
  service: ({accountId, modelId, modelName}, done) ->
    Model = db.models[modelName]

    queryObject = {_id: modelId}

    # inject accountId into query
    if modelName is 'Account'
      queryObject.merge {_id: accountId}
    else
      queryObject.merge {accountId}

    Model.findOne queryObject, (err, model) ->
      return done err if err or not model?

      model.remove (err) ->
        return done err if err
        return done null, {status: "#{modelName} removed"}
