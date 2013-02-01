db = config.require 'load/mongo'
async = require 'async'

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
      return done err if err

      async.map models, filterOutput, (err, data) ->
        done err, {data: data}
