db = config.require 'load/mongo'

module.exports =
  required: ['accountId', 'modelName', 'queryObject']
  service: ({accountId, queryObject, modelName}, done) ->
    queryObject.merge accountId: accountId

    Model = db.models[modelName]
    {filterOutput} = config.require "models/#{modelName}Filters"

    Model.find queryObject, (err, models) ->
      filteredModels = (filterOutput model for model in models)
      done err, filteredModels
