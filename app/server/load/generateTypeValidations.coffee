{getType} = config.require 'load/util'
argumentTypes = config.require 'load/argumentTypes'

# generate validations that will be added to the filter stack
generateValidations = (name, types, required) ->
  types.map (t) ->
    (args, next) ->
      #TODO: this is kind of ratty logic, it could probably be clearer with some async control flow

      # perform lookup if it exists
      if not args[name]? and t.lookup
        start = (end) ->
          t.lookup args, (err, result) ->
            return next err if err
            args[name] = result
            end()
      else
        start = (end) -> end()

      start ->
        # validate existence
        if not args[name]?
          if t.lookup
          else if required
            return next "Argument Required: #{name}"
          else
            return next null, args

        # run type validation
        if t.validation
          t.validation args[name], (passed) ->
            return next "Argument Validation: '#{name}' must be a valid #{t.typeName}." unless passed
            next null, args

        else
          next null, args


module.exports =

  # get a list of filter functions for a set of required/optional fields
  generateDefaultValidations: (fieldNames, required) ->
    validations =
      for name in fieldNames
        types = argumentTypes.findAll (t) -> t.defaultArgs and name in t.defaultArgs
        generateValidations name, types, required

    return validations.flatten()

  # get a list of filter functions for a set of detailed param specs
  generateValidationsFromParams: (paramSpecs) ->
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
          generateValidations param.name, types, param.required

    return validations.flatten()
