connect = require "connect"
Vein = require "vein"
mongo = require "./mongo"
config = require './config'
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

  # Redgoose
  redgoose.init()
  operator = require './domain/_cache/operators'
  session = require './domain/_cache/sessions'
  chat = require './domain/_cache/chats'
  redgoose.load operator
  redgoose.load session
  redgoose.load chat

  # Vein
  vein = new Vein server
  vein.use (req, res, next) -> #TODO: refactor this
    if req.service in ['login', 'signup', 'newChat', '', 'getChatHistory', 'getExistingChatChannel'] or req.service.match /^chat/
      next()
    else
      userSession = unescape res.cookie 'session'
      {Session} = redgoose.models
      Session.get(userSession).role.get (err, role) ->
        if role is 'operator'
          next()
        else
          res.cookie 'session', null
          next "#{req.service} not authorized"

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
