argumentValidations = config.require 'policy/middleware/argumentValidations'
policy = config.require 'policy/middleware/policy'
{policiesToFunctions} = config.require 'policy/middleware/middlewareTools'
{serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]

module.exports = (services) ->
  Object.map services, (sName, sDef) ->

    # lookup filters
    filters = serviceFilters[sName] or defaultFilters
    filters = filters.map (filter) ->
      (args, next) ->
        filter args, (err, out) ->
          return next "Filter: #{filter.filterName} did not return an object." unless err or (typeof out is 'object')
          next err, out

    sDef.prepend filters
