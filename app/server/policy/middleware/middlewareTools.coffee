# Purpose: this sets up the sugar we are using to define vein middleware

{tandoor} = config.require 'load/util'

routeValidators = {}

loadValidators = (validatorNames) ->
  validators = []
  for name in validatorNames
    validator = config.require "policy/validators/#{name}"
    throw new Error "validator #{name} not found" unless validator
    validators.push validator
  validators

module.exports =
  populateRoutes: (routeNames) ->
    for routeName in routeNames
      routeValidators[routeName] = []

  beforeFilter: (validatorNames, targetObject) =>
    validators = loadValidators validatorNames

    if targetObject.only?
      for route in targetObject.only
        routeValidators[route].push tandoor validator for validator in validators

    else if targetObject.except?
      allOtherRoutes = (routeName for routeName of routeValidators when routeName not in targetObject.except)
      for route in allOtherRoutes
        routeValidators[route].push tandoor validator for validator in validators

    else
      throw new Error "invalid validator target"

  getValidators: -> routeValidators
