db = config.require 'load/mongo'
globalModels = config.require 'load/globalModels'

module.exports = (accountId, queryObject, modelName, done) ->
  unless modelName in globalModels
    return done 'Could not determine account ID.' unless accountId
    queryObject.merge accountId: accountId

  Model = db.models[modelName]
  {filterOutput} = config.require "models/#{modelName}Filters"

  Model.find queryObject, (err, models) ->
    filteredModels = (filterOutput model for model in models)
    done err, filteredModels
