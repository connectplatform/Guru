{join} = require 'path'
require 'sugar'
Object.extend()

rel = (path) ->
  join __dirname, '../', path

environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      name: 'Guru'
      port: 4000
      pulsarPort: 4001
      ssl: false
      chats:
        minutesToTimeout: 15
      mail:
        transport: 'sendmail'
        options:
          args: ["-f info@livechathost.com"]
        getActivationLink: (uid, regkey) ->
          "http://localhost:4000/#/resetPassword?uid=#{uid}&regkey=#{regkey}"
      aws:
        s3:
          bucket: 'guru-dev'
          acl: 'public-read'
          maxSize: '102400'
        accessKey: 'AKIAILLS5MBMHVD62AEA'
        secretKey: '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'
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'

  production:
    app:
      name: 'Live Chat Host'
      port: 443
      pulsarPort: 4001
      ssl:
        key: "../../../../certs/privatekey.pem"
        cert: "../../../../certs/livechathost.com.crt"
        ca: ["../../../../certs/gd_bundle.crt"]
        redirectFrom: 80
      chats:
        minutesToTimeout: 15
      mail:
        transport: 'SES'
        options:
          AWSAccessKeyID: 'AKIAILLS5MBMHVD62AEA'
          AWSSecretKey: '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'
          from: 'info@livechathost.com'
        getActivationLink: (uid, regkey) ->
          "https://livechathost.com/#/resetPassword?uid=#{uid}&regkey=#{regkey}"
      # TODO: duplication!
      aws:
        s3:
          bucket: 'guru-prod'
          acl: 'public-read'
          maxSize: '102400'

    mongo:
      host: 'mongodb://guru:gk31Ql8151BTOS1@ds035137.mongolab.com:35137/guru-dev'

paths =
  root:       rel '.'
  npmBin:     rel './node_modules/.bin'

  app:        rel './app'
  client:     rel './app/client'
  public:     rel './app/public'

  server:     rel './app/server'
  load:       rel './app/server/load'
  models:     rel './app/server/models'
  policy:     rel './app/server/policy'
  services:   rel './app/server/services'
  rest:       rel './app/server/services/rest'
  views:      rel './app/server/views'

path = (spec) ->
  parts = spec.split '/'
  root = parts.shift()
  throw new Error "'#{root}' is not a path in config.coffee" unless paths[root]?
  join paths[root], parts.join '/'

global.config = config[environment].merge
  paths: paths
  path: path
  require: (spec) ->
    require path spec

module.exports = global.config
