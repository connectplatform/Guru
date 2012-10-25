async = require 'async'

argumentValidations = require './middleware/argumentValidations'
policy = require './middleware/policy'
{policiesToFunctions} = require './middleware/middlewareTools'

wireUpSideEffects = (stack, processSideEffects) ->
  for fn in stack
    # return signature required by waterfall
    (params, next) ->

      # run the filtered function
      fn params, (err, out, effects) ->
        return next err, out if err

        # perform any side effects
        processSideEffects effects, (err) ->
          next err, out

module.exports = (services) ->
  {serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]

  Object.map services, (serviceName, serviceDef) ->
    (res, params) ->

      setCookie = (effects, next) ->
        if effects?.setCookie?.sessionId
          res.cookie 'session', effects.setCookie.sessionId
        next()

      filters = serviceFilters[serviceName] or defaultFilters

      # build up call stack
      callStack = []
      callStack = callStack.concat filters
      callStack = callStack.concat serviceDef
      callStack = wireUpSideEffects callStack, setCookie

      # thread in input args
      callStack = [
        (next) -> next null, {sessionId: res.cookie 'session'}.merge params
      ].concat callStack

      async.waterfall callStack, res.reply
