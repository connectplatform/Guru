connect = require 'connect'

mongo = config.require 'load/mongo'
initStoic = config.require 'load/initStoic'
createServer = config.require 'load/createServer'
loadRest = config.require 'load/loadRest'
flushCache = config.require 'load/flushCache'
reconnectChannels = config.require 'load/reconnectChannels'

# service init, connect to interfaces
initServices = config.require 'load/initServices'
veinAdapter = config.require 'load/veinAdapter'

module.exports = (cb) ->

  port = (process.env.GURU_PORT or config.app.port)
  pulsarPort = (process.env.GURU_PULSAR_PORT or config.app.pulsarPort)

  initStoic ->

    reconnectChannels()

    # Web server
    app = connect()
    app.use (req, res, next) ->
      res.setHeader "Access-Control-Allow-Origin", "*"
      next()
    app.use connect.compress()
    app.use connect.responseTime()
    app.use connect.favicon()
    app.use connect.staticCache()
    app.use connect.query()
    app.use connect.cookieParser()
    app.use connect.static config.paths.public
    app.use connect.static config.paths.static if config.paths.static
    app.use loadRest config.paths.rest

    server = createServer port, app

    # attaches services to config.services
    initServices()

    # Wire up vein
    topLevelServices = Object.findAll config.services, (name) -> not name.has(/\//)
    veinAdapter(server) topLevelServices

    #restServices = Object.findAll config.services, (name) -> name.has /^rest\//
    #restAdapter(app) restServices

    # Good job, we made it!
    config.log.info "Server started on #{port}"
    config.log.info "Pulsar started on #{pulsarPort}"

    # Don't put connection strings in our logs
    if config.env is 'development'
      config.log.info "Using mongo database #{config.mongo.host}"
      config.log.info "Using redis database #{config.redis.database}"

    # measure memory usage
    if config.env is 'development'
      try
        memwatch = require 'memwatch'
        memwatch.on 'leak', (info) ->
          config.require('lib/sendStats') 'memory leak', info.growth

      catch error
        console.log 'Error logging memory leak:', error

    cb()
