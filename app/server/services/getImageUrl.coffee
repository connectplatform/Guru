getUrl = (ref, imageName) -> "https://s3.amazonaws.com/#{config.app.aws.s3.bucket}/website/#{ref}/#{imageName}"

module.exports =
  dependencies:
    services: ['websites/hasImage']
  optional: ['websiteId']
  required: ['imageName']
  service: ({websiteId, imageName}, done, {services}) ->
    done null, {url: getUrl('default', imageName)} unless websiteId

    services['websites/hasImage'] {websiteId: websiteId, imageName: imageName}, (err, {hasImage}) ->
      ref = if hasImage then websiteId else 'default'
      done err, {url: getUrl(ref, imageName)}
