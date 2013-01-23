getUrl = (ref, imageName) -> "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{ref}/#{imageName}"

module.exports =
  optional: ['websiteId']
  required: ['imageName']
  service: ({websiteId, imageName}, done) ->
    done null, {url: getUrl('default', imageName)} unless websiteId

    config.services['websites/hasImage'] {websiteId: websiteId, imageName: imageName}, (err, {hasImage}) ->
      ref = if hasImage then websiteId else 'default'
      done err, {url: getUrl(ref, imageName)}
