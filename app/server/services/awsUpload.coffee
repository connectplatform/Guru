crypto = require 'crypto'
objectToBase64 = (obj) -> (new Buffer JSON.stringify(obj)).toString('base64').replace '\n', ''
rsaSha1Encrypt = (secret, text) -> crypto.createHmac('sha1', secret).update(text).digest('base64').replace '\n', ''

module.exports = ({siteId, imageName}, done) ->
  # TODO: add whitelist for these strings in middleware

  fields = {}

  fields.key = "website/#{siteId}/#{imageName}"
  fields.awsAccessKey = config.app.aws.accessKey
  fields.acl = config.app.aws.s3.acl
  fields.bucket = config.app.aws.s3.bucket
  fields.maxSize = config.app.aws.s3.maxSize

  policy =
    expiration: new Date(Date.now() + (4 * 60 * 60 * 1000)) # 4 hours from now
    conditions: [
      {key: fields.key}
      {bucket: fields.bucket}
      {acl: fields.acl}
      ['content-length-range', 0, fields.maxSize]
      ['starts-with', '$Content-Type', 'image/']
    ]

  fields.policy = objectToBase64 policy
  fields.signature = rsaSha1Encrypt config.app.aws.secretKey, fields.policy

  done null, fields
