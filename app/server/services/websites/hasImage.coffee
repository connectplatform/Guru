{Website} = require('mongoose').models
cache = config.require 'load/cache'

module.exports =
  required: ['websiteId', 'imageName']
  service: ({websiteId, imageName}, done) ->
    cacheLocation = "hasImage/#{websiteId}/#{imageName}"
    field = "#{imageName}Uploaded"

    cached = cache.retrieve cacheLocation
    if cached?
      return done null, cached

    fields = {}
    fields[field] = true

    Website.findOne {_id: websiteId}, {}, (err, website) ->
      result = website?[field]
      cache.store cacheLocation, result
      done err, result
