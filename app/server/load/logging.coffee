winston = require 'winston'
{MongoDB} = require 'winston-mongodb'
url = require 'url'

module.exports = (options) ->
  loggers = {}

  makeLogger = (type) ->
    loggers[type] = new winston.Logger

    # some loggers (mongo) require the config for that persistance method
    loggerOptions = options[type]
    transport = loggerOptions.transport
    delete loggerOptions.transport
    if transport is 'MongoDB'

      connParts = url.parse config.mongo.host
      loggerOptions.merge
        host: connParts.hostname
        port: connParts.port || 27017
        db: connParts.pathname.replace '/', ''

      if connParts.auth
        [username, password] = connParts.auth.split ':'
        loggerOptions.merge
          username: username
          password: password

      #console.log 'options:', loggerOptions

    loggers[type].add winston.transports[transport], loggerOptions

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
