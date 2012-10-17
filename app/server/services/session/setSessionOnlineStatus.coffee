stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, isOnline, cb) ->
  Session.get(sessionId).online.set isOnline, (err) ->
    config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionId: sessionId} if err
    cb err
