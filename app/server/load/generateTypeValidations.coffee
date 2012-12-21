{getType} = config.require 'load/util'
argumentTypes = config.require 'load/argumentTypes'

# TODO: Consider refactoring to a goal oriented state machine - better control flow,
#       won't call Type Validations at all if arg not present and not required
#
# generate validations that will be added to the filter stack
generateValidations = (serviceName, name, types, required) ->
  stack = []

  # get lookups
  stack.add types.map (t) ->
    if t.lookup
      (args, next) ->

        # perform lookup if arg is not present
        if not args[name]?
          t.lookup args, (err, result) ->
            args[name] = result
            next err, args
        else
          next null, args

  # check existance
  stack.add (args, next) ->

    # validate existence
    if not args[name]? and required
      return next "#{serviceName} requires '#{name}' to be defined.", {}
    else
      return next null, args

  # get type validations
  stack.add types.map (t) ->
    if t.validation
      (args, next) ->

        # continue if field wasn't required/isn't present
        return next null, args unless args[name]

        # run type validation
        t.validation args[name], (passed) ->
          return next "#{serviceName} requires '#{name}' to be a valid #{t.typeName}.", {} unless passed
          next null, args

  # remove any lookups/validations that weren't defined
  stack.compact()


module.exports =

  # get a list of filter functions for a set of required/optional fields
  generateDefaultValidations: (serviceName, fieldNames, required) ->
    validations =
      for name in fieldNames
        types = argumentTypes.findAll (t) -> t.defaultArgs and name in t.defaultArgs
        generateValidations serviceName, name, types, required

    return validations.flatten()

  # get a list of filter functions for a set of detailed param specs
  generateValidationsFromParams: (serviceName, paramSpecs) ->
    validations =
      for param in paramSpecs

        # throw if required fields not present in spec
        for field in ['name', 'required', 'validation']
          throw new Error "invalid param: #{param}" unless field in param.keys()

        # find types and wrap in validations
        if getType(param.validation) is 'Function'
          param.validation

        else
          param.validation = [param.validation] unless getType(param.validation) is 'Array'
          types = argumentTypes.findAll (t) -> t.typeName in param.validation
          generateValidations serviceName, param.name, types, param.required

    return validations.flatten()
