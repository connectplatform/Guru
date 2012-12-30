argumentValidations = config.require 'policy/middleware/argumentValidations'
policy = config.require 'policy/middleware/policy'
{policiesToFunctions} = config.require 'policy/middleware/middlewareTools'

module.exports = (services) ->

  {filtersByService, defaultFilters} = policiesToFunctions [argumentValidations, policy]

  Object.map services, (serviceName, serviceDef) ->

    # lookup filters
    filters = filtersByService[serviceName] or defaultFilters
    filters = filters.map (filter) ->
      (args, next) ->
        filter args, (err, out) ->
          return next "Filter: #{filter.filterName} did not return an object." unless err or (typeof out is 'object')
          next err, out

    serviceDef.prepend filters
