# stoic = require 'stoic'
# {Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId', 'isOnline']
  service: ({sessionId, accountId, isOnline}, cb) ->
    Session(accountId).get(sessionId).online.set isOnline, (err) ->
      config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionId: sessionId} if err
      cb err
