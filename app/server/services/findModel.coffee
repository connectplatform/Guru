db = config.require 'load/mongo'

module.exports = (res, queryObject, modelName) ->
  Model = db.models[modelName]
  {filterOutput} = config.require "models/#{modelName}Filters"

  Model.find queryObject, (err, models) ->
    filteredModels = (filterOutput model for model in models)
    res.reply err, filteredModels
