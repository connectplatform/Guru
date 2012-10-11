async = require 'async'
argumentValidations = require './argumentValidations'
policy = require './policy'
{policiesToFunctions} = require './middlewareTools'

module.exports = (vein) ->
  {serviceFilters, defaultFilters} = policiesToFunctions [argumentValidations, policy]

  vein.use (req, res, next) ->
    args = req.args
    cookies = req.cookies

    filters = serviceFilters[req.service]
    packageFilters = (filters) -> (filter(args, cookies) for filter in filters)

    if filters?
      packagedFilters = packageFilters filters
    else
      packagedFilters = packageFilters defaultFilters

    async.series packagedFilters, (err) ->
      next err
