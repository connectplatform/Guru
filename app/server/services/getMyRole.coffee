stoic = require 'stoic'
{Session} = stoic.models

module.exports = ({sessionId}, done) ->
  return done null, {role: 'None'} unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    return done err, {role: 'None'} if err or not accountId
    Session(accountId).get(sessionId).role.get (err, role) ->
      role ||= 'None'
      done err, {role: role}
