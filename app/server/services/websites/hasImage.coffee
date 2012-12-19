{Website} = require('mongoose').models
cache = config.require 'load/cache'

module.exports =
  required: ['websiteId', 'imageName']
  service: ({websiteId, imageName}, done) ->
    cacheLocation = "hasImage/#{websiteId}/#{imageName}"
    field = "#{imageName}Url"

    cached = cache.retrieve cacheLocation
    if cached?
      return done null, cached

    fields = {}
    fields[field] = true

    Website.findOne {_id: websiteId}, fields, (err, website) ->
      result = website?[field]
      cache.store cacheLocation, result
      done err, result
