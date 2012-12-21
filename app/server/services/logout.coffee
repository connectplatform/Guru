stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, cb) ->
    Session(accountId).get(sessionId).delete (err) ->
      config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionId: sessionId} if err
      cb err, null, {setCookie: {sessionId: null}}
