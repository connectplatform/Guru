require '../../app/config'
{loadPolicies} = config.require 'policy/middleware/middlewareTools'
argumentValidations = config.require 'policy/middleware/argumentValidations'
policy = config.require 'policy/middleware/policy'

console.log loadPolicies [argumentValidations, policy]
