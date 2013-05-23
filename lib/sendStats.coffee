logger = require './logger'

module.exports = (stat, value, done) ->
  done or= ->
  enabled = config.statsMonitor?.enabled or []

  if (stat in enabled) or ('*' in enabled)
    method = switch config.statsMonitor?.receiver

      when 'statsd'
        {host, port} = config.statsMonitor

      when 'console'
        logger

      else
        logger

    method {stat, value}
  done()
