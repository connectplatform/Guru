module.exports = ->
  config.log 'Test log: log'
  config.log.info 'Test log: info'
  config.log.warn 'Test log: warn'
  config.log.error 'Test log: error'
  config.log.client.info 'Test log: client info'
  config.log.client.warn 'Test log: client warn'
  config.log.client.error 'Test log: client error'

  throw new Error 'Testing error logging'
