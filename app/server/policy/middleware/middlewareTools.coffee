# Purpose: this sets up the sugar we are using to define vein middleware

loadValidatorFunctions = (validatorNames) ->
  validators = []
  for name in validatorNames
    validator = config.require "policy/validators/#{name}"
    throw new Error "validator #{name} not found" unless validator
    validator.filterName = name
    validators.push validator
  validators

addRouteValidators = (route, validators, loaded) ->
  loaded.validatorsByRoute[route].push validator for validator in validators

initRoute = (route, loaded) ->
  if loaded.validatorsByRoute[route] is undefined
    loaded.validatorsByRoute[route] = []
    loaded.validatorsByRoute[route].push validator for validator in loaded.exceptValidators

onlyFilter = (validators, routes, loaded) ->
  for route in routes
    initRoute route, loaded
    addRouteValidators route, validators, loaded

exceptFilter = (validators, routes, loaded) ->
  initRoute route, loaded for route in routes
  loaded.exceptValidators.push validator for validator in validators
  for route of loaded.validatorsByRoute when route not in routes
    addRouteValidators route, validators, loaded

loadPolicies = (policies) ->
  loaded =
    validatorsByRoute: {}
    exceptValidators: []
  for policy in policies
    for rule in policy
      throw new Error "Error loading policy: Validations must contain array of filters" unless rule.filters?
      if rule.only?
        onlyFilter rule.filters, rule.only, loaded
      else if rule.except?
        exceptFilter rule.filters, rule.except, loaded
  { serviceFilters: loaded.validatorsByRoute, defaultFilters: loaded.exceptValidators }

loadFunctions = ({serviceFilters, defaultFilters}) ->
  loadedServiceFilters = {}
  loadedDefaultFilters = []
  for route, validators of serviceFilters
    loadedServiceFilters[route] = loadValidatorFunctions validators
  loadedDefaultFilters = loadValidatorFunctions defaultFilters
  return {serviceFilters: loadedServiceFilters, defaultFilters: loadedDefaultFilters}

policiesToFunctions = (policies) ->
  loadFunctions loadPolicies policies

module.exports =
  loadPolicies: loadPolicies
  policiesToFunctions: policiesToFunctions
