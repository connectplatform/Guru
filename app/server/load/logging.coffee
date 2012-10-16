winston = require 'winston'
require('winston-mongodb').MongoDB

loggers = {}

makeLogger = (type) ->
  loggers[type] = new winston.Logger()
  options =
    db: config.mongo.name
    host: config.mongo.domain
    port: config.mongo.port
    username: config.mongo.username
    password: config.mongo.password
    collection: "#{type}Logs"
    capped: true
    cappedSize: 104857600 #100 MB
  loggers[type].add winston.transports.MongoDB, options

makeLogger 'client'
makeLogger 'server'

module.exports =
  info: loggers.server.info
  warn: loggers.server.warn
  error: loggers.server.error

  client:
    info: loggers.client.info
    warn: loggers.client.warn
    error: loggers.client.error
