require 'sugar'
Object.extend()

connect = require 'connect'
Vein = require 'vein'
mongo = require './mongo'
pulsar = require './pulsar'
initStoic = require './initStoic'
createServer = require './createServer'
loadRest = require './loadRest'
flushCache = config.require 'load/flushCache'

getServices = config.require 'load/getServices'
connectVeinServices = config.require 'load/getServices'
wrapServicesInMiddleware = config.require 'policy/wrapServicesInMiddleware'

module.exports = (cb) ->

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

    # Vein
    vein = Vein.createServer server: server
    services = getServices config.paths.services
    wrappedServices = wrapServicesInMiddleware services # TODO: store these in config.services
    #veinServices = wrapServicesInVein wrappedServices
    for name, service of wrappedServices
      vein.add name, service

    config.log.info "Server started on #{port}"
    config.log.info "Pulsar started on #{config.app.pulsarPort}"
    config.log.info "Using mongo database #{config.mongo.host}"
    config.log.info "Using redis database #{config.redis.database}"
    cb()
