stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, cookies, cb) ->
  sessionId = cookies.session
  return cb "expected cookie: {session: sessionId}" unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      unless (role is "Administrator") or (role is "Supervisor") or (role is "Operator")
        return cb "You are not a registered user"
      cb()
