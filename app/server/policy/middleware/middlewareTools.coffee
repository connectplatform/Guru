# Purpose: this sets up the sugar we are using to define vein middleware

{tandoor} = config.require 'load/util'

validatorsByRoute = {}
exceptValidators = []

loadValidators = (validatorNames) ->
  validators = []
  for name in validatorNames
    validator = config.require "policy/validators/#{name}"
    throw new Error "validator #{name} not found" unless validator
    validators.push validator
  validators

addRouteValidators = (route, validators) ->
  validatorsByRoute[route].push tandoor validator for validator in validators

initRoute = (route) ->
  if validatorsByRoute[route] is undefined
    console.log 'initing ', route
    validatorsByRoute[route] = []
    validatorsByRoute[route].push validator for validator in exceptValidators

onlyFilter = (validators, routes) ->
  for route in routes
    initRoute route
    addRouteValidators route, validators

exceptFilter = (validators, routes) ->
  initRoute route for route in routes
  exceptValidators.push tandoor validator for validator in validators
  for route of validatorsByRoute when route not in routes
    addRouteValidators route, validators

module.exports =
  getValidators: -> validatorsByRoute

  getDefaultValidators: -> exceptValidators

  loadPolicies: (policies) ->
    for policy in policies
      for rule in policy

        if rule.filters?
          validators = loadValidators rule.filters
        else
          throw new Error "Error loading policy: Validations must contain array of filters"

        if rule.only?
          onlyFilter validators, rule.only
        else if rule.except?
          exceptFilter validators, rule.except
