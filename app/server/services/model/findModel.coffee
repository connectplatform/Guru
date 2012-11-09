db = config.require 'load/mongo'

module.exports =
  required: ['accountId', 'modelName', 'queryObject']
  service: ({accountId, queryObject, modelName}, done) ->
    if modelName isnt 'Account'
      queryObject.merge accountId: accountId
    else
      queryObject.merge _id: accountId

    Model = db.models[modelName]
    {filterOutput} = config.require "models/#{modelName}Filters"

    Model.find queryObject, (err, models) ->
      filteredModels = (filterOutput model for model in models)
      done err, filteredModels
