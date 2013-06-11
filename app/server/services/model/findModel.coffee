db = config.require 'load/mongo'
async = require 'async'

module.exports =
  required: ['modelName', 'queryObject']
  service: ({queryObject, modelName}, done) ->
    Model = db.models[modelName]
    {filterOutput} = config.require "models/#{modelName}Filters"

    Model.find queryObject, (err, models) ->
      return done err if err

      async.map models, filterOutput, (err, data) ->
        done err, {data: data}
