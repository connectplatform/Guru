async = require 'async'

argumentValidations = require './middleware/argumentValidations'
policy = require './middleware/policy'
{policiesToFunctions} = require './middleware/middlewareTools'

module.exports = (services) ->
  {serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]

  wrappedServices = {}

  for serviceName, serviceDef of services

    wrappedServices[serviceName] = (res, params) ->

      # build up call stack
      callStack = [(next) -> next params.merge {sessionId: res.cookie 'session'}]
      callStack.concat serviceFilters[serviceName] or defaultFilters
      callStack.concat serviceDef
      # TODO: apply side effects for output params

      async.waterfall callStack, res.reply

  return wrappedServices
