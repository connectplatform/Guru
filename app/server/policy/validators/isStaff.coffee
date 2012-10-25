stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, next) ->
  {sessionId} = args
  return next "expected argument: sessionId" unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      unless role in ["Administrator", "Supervisor", "Operator"]
        return next "You are not a registered user"
      next null, args
