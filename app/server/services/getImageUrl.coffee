getUrl = (ref, imageName) -> "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{ref}/#{imageName}"

module.exports =
  optional: ['websiteId']
  required: ['imageName']
  service: ({websiteId, imageName}, done) ->
    done null, getUrl('default', imageName) unless websiteId

    hasImage = config.service 'websites/hasImage'

    hasImage {websiteId: websiteId, imageName: imageName}, (err, result) ->
      ref = if result then websiteId else 'default'
      done err, getUrl(ref, imageName)
