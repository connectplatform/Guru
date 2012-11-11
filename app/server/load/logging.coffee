winston = require 'winston'
require 'sugar'
require('winston-mongodb').MongoDB

module.exports = (options) ->
  loggers = {}

  makeLogger = (type) ->
    loggers[type] = new winston.Logger

    # some loggers (mongo) require the config for that persistance method
    loggerOptions = options[type]
    if loggerOptions.transport is 'MongoDB'
      loggerOptions.merge
        host: config.mongo.host
        db: config.mongo.name

    loggers[type].add winston.transports[loggerOptions.transport], loggerOptions

  makeLogger 'client'
  makeLogger 'server'

  unless config.env is 'development'
    process.on 'uncaughtException', (err) ->
      #process.removeAllListeners 'uncaughtException'
      loggers.server.error 'Uncaught Exception', {exception: err.toString()}, ->
        throw err

  log = loggers.server.info
  log.info = loggers.server.info
  log.warn = loggers.server.warn
  log.error = loggers.server.error

  log.client =
    info: loggers.client.info
    warn: loggers.client.warn
    error: loggers.client.error

  return log
