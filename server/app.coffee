connect = require "connect"
Vein = require "vein"
mongo = require "./mongo"
config = require './config'

module.exports = (port) ->
  port ?= config.app.port

  # Web server
  app = connect()
  app.use connect.responseTime()
  app.use connect.favicon()
  app.use connect.staticCache()
  app.use connect.static __dirname + '/../public/'

  server = app.listen port

  # Vein
  vein = new Vein server
  vein.use (req, res, next) ->
    if req.service in ['login', 'signup', 'newChat', '', 'getChatHistory'] or req.service.match /^chat/
      next()
    else
      if res.cookie('login')? #TODO: verify this
        next()
      else
        next('not authorized')

  vein.addFolder __dirname + '/domain/_services/'

  #refactor me out
  newChat = require './domain/newChat'
  newChat vein

  console.log "Server started on #{port}"
  console.log "Using database #{config.mongo.host}"