async = require 'async'

wireUpSideEffects = config.require 'load/wireUpSideEffects'
getTypeValidations = config.require 'load/getTypeValidations'

module.exports = (services) ->

  Object.map services, (serviceName, serviceDef) ->

    typeValidations = getTypeValidations serviceName, serviceDef
    service = serviceDef.service or serviceDef

    # build up static portion call stack
    preStack = []
    preStack.add typeValidations
    preStack.add service

    # return wrapped service
    wrapper = (params, done, processSideEffects) ->
      processSideEffects ||= (effects, cb) -> cb()
      #console.log 'typeValidations:', typeValidations.map((t) -> t.toString()).join '\n\n'

      # intercept side effects from stack and pass to processor
      callStack = wireUpSideEffects preStack, processSideEffects

      # start call stack with input args
      callStack.unshift (next) -> next null, params

      async.waterfall callStack, done

    wrapper.prepend = (services) ->
      preStack.unshift services...

    return wrapper
