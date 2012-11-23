getServices = config.require 'load/getServices'
wrapServicesInMiddleware = config.require 'policy/wrapServicesInMiddleware'

module.exports = ->

  # Wire up services
  services = getServices config.paths.services
  config.services = wrapServicesInMiddleware services
