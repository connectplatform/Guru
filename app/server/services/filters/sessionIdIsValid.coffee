stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, next) ->
  {sessionId} = args
  return next 'You must be logged in to access this feature.' unless sessionId

  Session.accountLookup.get sessionId, (err, accountId) ->
    return next 'You must be logged in to access this feature.' unless accountId

    Session(accountId).allSessions.ismember sessionId, (err, sessionExists) ->
      return next 'You must be logged in to access this feature.' unless sessionExists is 1
      next null, args
