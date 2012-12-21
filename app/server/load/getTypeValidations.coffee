{getType} = config.require 'load/util'
{generateDefaultValidations, generateValidationsFromParams} = config.require 'load/generateTypeValidations'

module.exports = (serviceName, serviceDef) ->
  switch getType serviceDef

    when 'Function'
      return []

    when 'Object'
      validations = []
      {required, optional, params} = serviceDef

      if required
        validations.add generateDefaultValidations serviceName, required, true

      if optional
        validations.add generateDefaultValidations serviceName, optional, false

      if params
        validations.add generateValidationsFromParams serviceName, params

      return validations

    else
      throw new Error "Service '#{serviceName}' is not an object or a function."
