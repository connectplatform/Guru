async = require 'async'
{populateRoutes, getValidators} = require './middlewareTools'

{getType} = require '../../lib/util'

mapArgs = (arg) ->
  if (getType arg is '[object Object]') and arg.socket? and arg.name? and arg.listeners?
    return arg.name
  else
    return arg

module.exports = (vein, policy) ->
  veinServices = Object.keys vein.services

  populateRoutes veinServices
  policy()
  routeValidators = getValidators()

  vein.use (req, res, next) ->
    validators = routeValidators[req.service]
    return next 'Invalid service' unless validators?
    args = req.args.map mapArgs
    cookies = req.cookies

    packagedValidators = []
    packagedValidators.push validator args, cookies for validator in validators

    async.series packagedValidators, (err) ->
      next err
