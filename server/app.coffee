connect = require "connect"
Vein = require "vein"
mongo = require "./mongo"
pulsar = require "./pulsar"
config = require './config'
flushCache = require '../lib/flushCache'
http = require 'http'

redgoose = require 'redgoose'

module.exports = (cb) ->
  port = (process.env.GURU_PORT or config.app.port)

  # Web server
  app = connect()
  app.use connect.responseTime()
  app.use connect.favicon()
  app.use connect.staticCache()
  app.use connect.static __dirname + '/../public/'

  server = app.listen port

  # Redgoose
  redgoose.init()
  redgoose.load require model for model in [
    './domain/_models/sessions'
    './domain/_models/chats'
    './domain/_models/operatorChat'
  ]

  # Vein
  vein = new Vein server
  vein.use (req, res, next) -> #TODO: refactor this
    if req.service in ['login', 'signup', 'newChat', '', 'getChatHistory', 'getExistingChatChannel'] or req.service.match /^chat/
      console.log 'no auth needed'
      next()

    else
      userSession = unescape res.cookie 'session'
      {Session} = redgoose.models
      Session.get(userSession).role.get (err, role) ->
        if (role is 'Operator') or (role is 'Admin')
          console.log 'error:', err if err?
          console.log "#{role} user authorized"
          next()
        else
          res.cookie 'session', null
          console.log 'role:', role
          console.log 'session:', res.cookie 'session'
          next "#{req.service} not authorized"

  vein.addFolder __dirname + '/domain/_services/'

  #flush cache
  flushCache ->
    console.log "Server started on #{port}"
    console.log "Pulsar started on #{config.app.pulsarPort}"
    console.log "Using database #{config.mongo.host}"
    cb()
