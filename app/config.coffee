{join, resolve} = require 'path'
require 'sugar'
Object.extend()

environment = process.env.NODE_ENV or 'development'

config =
  development:
    app:
      port: 4000
      pulsarPort: 4001
      ssl: false
    mongo:
      host: 'mongodb://localhost:27017/guru-dev'

  production:
    app:
      port: 443
      pulsarPort: 4001
      ssl:
        key: resolve "../../certs/privatekey.pem"
        cert: resolve "../../certs/livechathost.com.crt"
        ca: [resolve "../../certs/gd_bundle.crt"]
        redirectFrom: 80
    mongo:
      host: 'mongodb://guru:gk31Ql8151BTOS1@ds035137.mongolab.com:35137/guru-dev'

paths =
  root:       resolve '.'
  npmBin:     resolve './node_modules/.bin'

  app:        resolve './app'
  client:     resolve './app/client'
  public:     resolve './app/public'

  server:     resolve './app/server'
  load:       resolve './app/server/load'
  models:     resolve './app/server/models'
  services:   resolve './app/server/services'
  policy:     resolve './app/server/policy'
  middleware: resolve './app/server/middleware'


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
