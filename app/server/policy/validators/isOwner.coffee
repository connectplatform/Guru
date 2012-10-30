stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, next) ->
  {sessionId} = args
  return next "expected arg: {session: sessionId}" unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      return next "You must be an account Owner to access this feature." unless role is 'Owner'
      next null, args
