stoic = require 'stoic'
{Session} = stoic.models

redisId = /[a-z0-9]{16}/

module.exports = [
    typeName: 'String'
    validation: (arg, assert) ->
      return assert typeof arg is 'string'
    defaultArgs: ['email', 'password']
  ,
    typeName: 'AccountId'
    lookup: ({sessionId}, found) ->
      return found "Could not look up AccountId. No SessionId provided." unless sessionId
      Session.accountLookup.get sessionId, (err, accountId) ->
        found null, accountId
    defaultArgs: ['accountId']
  ,
    typeName: 'SessionId'
    validation: (arg, assert) ->
      return assert (typeof arg is 'string') and arg.match redisId
    defaultArgs: ['sessionId']
]
