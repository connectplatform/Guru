winston = require 'winston'
require('winston-mongodb').MongoDB

module.exports = (options) ->
  loggers = {}

  makeLogger = (type) ->
    loggers[type] = new winston.Logger()
    options =
      db: options.name
      name: options.name
      host: options.domain
      port: options.port
      username: options.username
      password: options.password
      collection: "#{type}Logs"
      capped: true
      cappedSize: 104857600 #100 MB
      level: options.logLevel

    loggers[type].add winston.transports.MongoDB, options

  makeLogger 'client'
  makeLogger 'server'

  process.on 'uncaughtException', (err) ->
    process.removeAllListeners 'uncaughtException'
    loggers.server.error 'Uncaught Exception', {exception: err.toString()}, ->
      throw err

  return loggers
