require 'sugar'
Object.extend()

connect = require "connect"
Vein = require "vein"

mongo = require "./mongo"
pulsar = require "./pulsar"
stoic = require './initStoic'
createServer = require './createServer'

flushCache = config.require 'services/flushCache'

module.exports = (cb) ->

  port = (process.env.GURU_PORT or config.app.port)

  # Web server
  app = connect()
  app.use connect.responseTime()
  app.use connect.favicon()
  app.use connect.staticCache()
  app.use connect.static config.paths.public

  server = createServer port, app

  # Vein
  vein = Vein.createServer server: server
  vein.addFolder config.paths.services

  veinMiddlewareGlue = config.require 'policy/middleware/veinMiddlewareGlue'
  veinMiddlewareGlue vein

  #flush cache
  flushCache ->
    console.log "Server started on #{port}"
    console.log "Pulsar started on #{config.app.pulsarPort}"
    console.log "Using database #{config.mongo.host}"
    cb()