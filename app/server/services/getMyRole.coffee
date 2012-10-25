stoic = require 'stoic'
{Session} = stoic.models

module.exports = ({sessionId}, done) ->
  sessionId = res.cookie 'session'
  return done null, 'None' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    return done err, 'None' if err or not accountId
    Session(accountId).get(sessionId).role.get (err, role) ->
      role ||= 'None'
      done err, role
