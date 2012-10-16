{join} = require 'path'
require 'sugar'
Object.extend()

logging = require './server/load/logging'

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
        transport: 'SES'
        options:
          AWSAccessKeyID: 'AKIAILLS5MBMHVD62AEA'
          AWSSecretKey: '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'
          from: 'info@livechathost.com'
          support: 'success@simulator.amazonses.com'
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
      name: 'guru-dev'
      domain: 'localhost'
      port: 27017
    redis:
      database: 0

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
          support: 'support@livechathost.com'
        getActivationLink: (uid, regkey) ->
          "https://livechathost.com/#/resetPassword?uid=#{uid}&regkey=#{regkey}"
      # TODO: duplication!
      aws:
        s3:
          bucket: 'guru-prod'
          acl: 'public-read'
          maxSize: '102400'
        accessKey: 'AKIAILLS5MBMHVD62AEA'
        secretKey: '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'

    mongo:
      host: 'mongodb://guru:gk31Ql8151BTOS1@ds035137.mongolab.com:35137/guru-dev'
      name: 'guru-dev'
      domain: 'ds035137.mongolab.com'
      port: 35137
      username: 'guru'
      password: 'gk31Ql8151BTOS1'
    redis:
      database: 1

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

# Logging
loggingOptions = config[environment].mongo
loggingOptions.logLevel = 'info'
loggers = logging loggingOptions

global.config = config[environment].merge
  env: environment
  paths: paths
  path: path
  require: (spec) ->
    require path spec
  info: loggers.server.info
  warn: loggers.server.warn
  error: loggers.server.error
  clientInfo: loggers.client.info
  clientWarn: loggers.client.warn
  clientError: loggers.client.error

module.exports = global.config
