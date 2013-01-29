stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  optional: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    return done null, {role: 'None'} unless sessionId and accountId

    Session(accountId).get(sessionId).role.get (err, role) ->
      role ||= 'None'
      done err, {role: role}
