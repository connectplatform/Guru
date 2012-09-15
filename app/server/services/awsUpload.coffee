crypto = require 'crypto'
objectToBase64 = (obj) -> (new Buffer JSON.stringify(obj)).toString('base64').replace '\n', ''
rsaSha1Encrypt = (secret, text) -> crypto.createHmac('sha1', secret).update(text).digest('base64').replace '\n', ''

devBucket =
  bucket: 'guru-dev'
  awsAccessKey: 'AKIAILLS5MBMHVD62AEA'
  key: 'aFile'
  acl: 'private'
  secret: '4IdLGyU52rbz3pFrTLJjgZIJnyT7FkrxRQTSrJDr'
  redirect: ''
  maxSize: '10485760'

module.exports = (res) ->
  console.log "entered awsUpload"

  fields = {}

  fields.key = devBucket.key
  fields.awsAccessKey = devBucket.awsAccessKey
  fields.acl = devBucket.acl
  fields.redirect = devBucket.redirect
  fields.bucket = devBucket.bucket
  fields.contentType = 'image/jpeg'

  policy =
    expiration: new Date(Date.now() + (4 * 60 * 60 * 1000)) # 4 hours from now
    conditions: [
      {key: devBucket.key}
      {bucket: devBucket.bucket}
      {acl: devBucket.acl}
      {success_action_redirect: devBucket.redirect}
      ['content-length-range', 0, devBucket.maxSize]
      {'Content-Type': fields.contentType}
    ]

  fields.policy = objectToBase64 policy
  fields.signature = rsaSha1Encrypt devBucket.secret, fields.policy

  console.log "leaving awsUpload"
  res.reply null, fields
