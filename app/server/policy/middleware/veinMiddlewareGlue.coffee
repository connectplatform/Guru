async = require 'async'
argumentValidations = require './argumentValidations'
policy = require './policy'
{getValidators, getDefaultValidators, loadPolicies} = require './middlewareTools'

module.exports = (vein) ->
  loadPolicies [argumentValidations, policy]
  routeValidators = getValidators()
  defaultValidators = getDefaultValidators()

  vein.use (req, res, next) ->
    args = req.args
    cookies = req.cookies

    validators = routeValidators[req.service]

    if validators?
      packagedValidators = (validator(args, cookies) for validator in validators)
    else
      packagedValidators = (validator(args, cookies) for validator in defaultValidators)

    async.series packagedValidators, (err) ->
      next err
