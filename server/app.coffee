connect = require "connect"
Vein = require "vein"
mongo = require "./mongo"
config = require './config'
redis = require './redis'
flushCache = require '../lib/flushCache'

redgoose = require 'redgoose'

module.exports = (port, cb) ->
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
  vein.use (req, res, next) -> #TODO: refactor this
    if req.service in ['login', 'signup', 'newChat', '', 'getChatHistory', 'getExistingChatChannel'] or req.service.match /^chat/
      next()
    else
      redis.sessions.role unescape(res.cookie('session')), (err, data)->
        if data is 'operator'
          next()
        else
          next('not authorized')

  # Redgoose
  redgoose.createClient()
  operator = require './domain/_cache/operators'
  redgoose.load operator

  #TODO: refactor me out
  newChat = require './domain/newChat'
  newChat vein
  getExistingChatChannel = require './domain/getExistingChatChannel'
  getExistingChatChannel vein

  vein.addFolder __dirname + '/domain/_services/'

  #flush cache
  flushCache ->
    console.log "Server started on #{port}"
    console.log "Using database #{config.mongo.host}"
    cb()