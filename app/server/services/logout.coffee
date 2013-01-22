stoic = require 'stoic'
{Session} = stoic.models

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, cb) ->
    Session(accountId).get(sessionId).delete (err) ->
      config.log.error 'Error logging out.', {error: err, sessionId: sessionId} if err
      cb err, {sessionId: null}
