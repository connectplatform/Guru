{create} = require 'law'
jargon = config.require 'policy/jargon'
policy = config.require 'policy/policy'

module.exports = ->

  # Wire up services
  config.services = create config.paths.services, jargon, policy
