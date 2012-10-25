stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, next) ->
  {sessionId} = args
  return next "expected cookie: {session: sessionId}" unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      return next "You are not an administrator" unless role is "Administrator"
      next null, args
