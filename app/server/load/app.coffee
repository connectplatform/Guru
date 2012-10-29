require 'sugar'
Object.extend()

connect = require 'connect'
mongo = require './mongo'
initStoic = require './initStoic'
createServer = require './createServer'
loadRest = require './loadRest'
flushCache = config.require 'load/flushCache'

getServices = config.require 'load/getServices'
wrapServicesInMiddleware = config.require 'policy/wrapServicesInMiddleware'
veinAdapter = config.require 'load/veinAdapter'

module.exports = (cb) ->

  # this creates the server as soon as you require it
  pulsar = require './pulsar'

  port = (process.env.GURU_PORT or config.app.port)

  initStoic ->

    # Web server
    app = connect()
    app.use connect.responseTime()
    app.use connect.favicon()
    app.use connect.staticCache()
    app.use connect.static config.paths.public
    app.use loadRest config.paths.rest

    server = createServer port, app

    # Wire up services
    services = getServices config.paths.services
    config.services = wrapServicesInMiddleware services

    # Wire up vein
    topLevelServices = Object.findAll config.services, (name) -> name.match /[^\/]/
    veinAdapter(server) topLevelServices

    # Good job, we made it!
    config.log.info "Server started on #{port}"
    config.log.info "Pulsar started on #{config.app.pulsarPort}"

    # Don't put connection strings in our logs
    if config.env is 'development'
      config.log.info "Using mongo database #{config.mongo.host}"
      config.log.info "Using redis database #{config.redis.database}"

    cb()
