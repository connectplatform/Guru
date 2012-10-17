{loadPolicies} = config.require 'policy/middleware/middlewareTools'
argumentValidations = config.require 'policy/middleware/argumentValidations'
policy = config.require 'policy/middleware/policy'

module.exports = ->
  console.log loadPolicies [argumentValidations, policy]
  process.exit()
