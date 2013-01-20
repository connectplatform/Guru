{Website} = require('mongoose').models
cache = config.require 'load/cache'

module.exports =
  required: ['websiteId', 'imageName']
  service: ({websiteId, imageName}, done) ->
    cacheLocation = "hasImage/#{websiteId}/#{imageName}"
    imageFlag = "#{imageName}Uploaded"

    cached = cache.retrieve cacheLocation
    if cached?
      return done null, {hasImage: cached}

    fields = {}
    fields[imageFlag] = true

    Website.findOne {_id: websiteId}, {}, (err, website) ->
      result = website?[imageFlag]
      cache.store cacheLocation, result
      done err, {hasImage: result}
