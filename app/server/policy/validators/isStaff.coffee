stoic = require 'stoic'
{Session} = stoic.models

enums = config.require 'load/enums'

module.exports = (args, next) ->
  {sessionId} = args
  return next 'Argument Required: sessionId' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      unless role in enums.staffRoles
        return next "You must login to access this feature."
      next null, args
