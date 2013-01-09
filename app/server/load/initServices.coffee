{create} = require 'law'
argumentTypes = config.require 'load/argumentTypes'
policy = config.require 'policy/policy'

module.exports = ->

  # Wire up services
  config.services = create config.paths.services, argumentTypes, policy
