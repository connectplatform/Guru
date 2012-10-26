async = require 'async'

argumentValidations = require './middleware/argumentValidations'
policy = require './middleware/policy'
{policiesToFunctions} = require './middleware/middlewareTools'
{serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]
wireUpSideEffects = config.require 'load/wireUpSideEffects'

module.exports = (services) ->

  Object.map services, (serviceName, serviceDef) ->
    (params, done, processSideEffects) ->

      filters = serviceFilters[serviceName] or defaultFilters
      filters = filters.map (filter) ->
        (args, next) ->
          filter args, (err, out) ->
            return next "Filter: #{filter.filterName} did not return an object." unless err or (typeof out is 'object')
            next err, out

      # build up call stack
      callStack = []
      callStack = callStack.concat filters
      callStack = callStack.concat serviceDef
      callStack = wireUpSideEffects callStack, processSideEffects

      # thread in input args
      callStack = [
        (next) -> next null, params
      ].concat callStack

      async.waterfall callStack, done
