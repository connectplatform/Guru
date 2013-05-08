{join} = require 'path'
require 'sugar'
Object.extend()

initLogging = require './server/load/logging'

rel = (path) ->
  join __dirname, '../', path

environment = process.env.NODE_ENV or 'development'

devHost = 'localhost'
config =
  development:
    app:
      name: 'Guru'
      url: 'http://#{devHost}:4000/chat.html'
      baseUrl: 'http://#{devHost}:4000'
      api: null
      port: 4000
      pulsarPort: 4001
      ssl: false
        #key: rel 'tmp/certs/test.com.key'
        #cert: rel 'tmp/certs/test.com.crt'
      chats:
        minutesToTimeout: 15
      mail:
        transport: 'SES'
        options:
          AWSAccessKeyID: 'AKIAILLS5MBMHVD62AEA'
          AWSSecretKey: '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'
          from: 'info@chatpro.com'
          support: 'success@simulator.amazonses.com'
        getActivationLink: (uid, regkey) ->
          "http://#{devHost}:4000/chat.html#/resetPassword?uid=#{uid}&regkey=#{regkey}"
      aws:
        s3:
          bucket: 'guru-dev'
          acl: 'public-read'
          maxSize: '10485760'
        s3_static:
          bucket: 'guru-test'
        accessKey: 'AKIAILLS5MBMHVD62AEA'
        secretKey: '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'
    adminNotify: ['brandon@torchlightsoftware.com', 'automart@gmail.com']
    recurly:
      apiKey: '162807d2b937497ca43e25db7a01380b'
      apiUrl: 'https://api.recurly.com/v2/'
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'
    redis:
      database: 0
    logging:
      client:
        level: 'info'
        transport: 'Console'
        timestamp: true
      server:
        level: 'info'
        transport: 'Console'
        timestamp: true

paths =
  root:       rel '.'
  npmBin:     rel 'node_modules/.bin'
  scripts:    rel 'scripts/sources'
  data:       rel 'data'
  test:       rel 'test/server'

  app:        rel 'app'
  client:     rel 'app/client'
  public:     rel 'app/public'
  #static:     rel 'tmp/static'

  server:     rel 'app/server'
  load:       rel 'app/server/load'
  models:     rel 'app/server/models'
  policy:     rel 'app/server/policy'
  services:   rel 'app/server/services'
  rest:       rel 'app/server/services/rest'
  views:      rel 'app/server/views'

path = (spec) ->
  parts = spec.split '/'
  root = parts.shift()
  throw new Error "'#{root}' is not a path in config.coffee" unless paths[root]?
  join paths[root], parts.join '/'

# sensible error message if env is wrong
unless config[environment]
  console.log "Could not find config for environment: [#{environment}].  Valid environments: [#{Object.keys(config).join ', '}]"
  process.exit(1)

global.config = config[environment].merge
  env: environment
  paths: paths
  path: path
  require: (spec) ->
    require path spec
  services: {} # loaded with application
  service: (serviceName) ->
    global.config.services[serviceName]

global.config.log = initLogging global.config.logging

module.exports = global.config
