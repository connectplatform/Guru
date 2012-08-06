{tandoor} = require '../../lib/util'

routeValidators = {}

loadValidators = (validatorNames) ->
  validators = []
  for name in validatorNames
    validator = require __dirname + '/validators/' + name
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
      allOtherRoutes = (routeName for routeName of routeValidators when targetObject.except.indexOf(routeName) is -1)
      for route in allOtherRoutes
        routeValidators[route].push tandoor validator for validator in validators

    else
      throw new Error "invalid validator target"

  getValidators: -> routeValidators
