async = require 'async'

argumentValidations = require './middleware/argumentValidations'
policy = require './middleware/policy'
{policiesToFunctions} = require './middleware/middlewareTools'
{serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]
wireUpSideEffects = config.require 'load/wireUpSideEffects'
getTypeValidations = config.require 'load/getTypeValidations'

module.exports = (services) ->

  Object.map services, (serviceName, serviceDef) ->

    # lookup filters
    filters = serviceFilters[serviceName] or defaultFilters
    filters = filters.map (filter) ->
      (args, next) ->
        filter args, (err, out) ->
          return next "Filter: #{filter.filterName} did not return an object." unless err or (typeof out is 'object')
          next err, out

    typeValidations = getTypeValidations serviceName, serviceDef
    service = serviceDef.service or serviceDef

    # build up static portion call stack
    preStack = []
    preStack.add typeValidations
    preStack.add filters
    preStack.add service

    # return wrapped service
    (params, done, processSideEffects) ->
      #console.log 'typeValidations:', typeValidations.map((t) -> t.toString()).join '\n\n'

      # intercept side effects from filters and service and pass to processor
      callStack = wireUpSideEffects preStack, processSideEffects

      # start call stack with input args
      callStack.unshift (next) -> next null, params

      async.waterfall callStack, done
