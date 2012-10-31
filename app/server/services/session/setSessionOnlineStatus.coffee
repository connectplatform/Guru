stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, isOnline, cb) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).online.set isOnline, (err) ->
      config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionId: sessionId} if err
      cb err
