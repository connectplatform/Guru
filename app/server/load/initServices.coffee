{create, applyDependencies} = require 'law'
jargon = config.require 'policy/jargon'
policy = config.require 'policy/policy'

module.exports = ->

  # Wire up services
  config.services = create config.paths.services, jargon, policy

  # Set up resolvers for service dependencies
  resolvers =
    services: (name) -> config.services[name]

  config.services = applyDependencies config.services, resolvers