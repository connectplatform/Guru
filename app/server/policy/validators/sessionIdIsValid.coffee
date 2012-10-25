stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, next) ->
  {sessionId} = args
  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).allSessions.ismember sessionId, (err, sessionExists) ->
      return next 'invalid or expired session Id' unless sessionExists is 1
      next null, args
