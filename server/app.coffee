connect = require "connect"
Vein = require "vein"
mongo = require "./mongo"
config = require './config'

module.exports = ->

  # Web server
  app = connect()
  app.use connect.responseTime()
  app.use connect.favicon()
  app.use connect.staticCache()
  app.use connect.static __dirname + '/public/'

  server = app.listen config.app.port

  # Vein
  vein = new Vein server
  vein.addFolder __dirname + '/services/'

  console.log "Server started on #{config.app.port}"
  console.log "Using database #{config.mongo.host}"
