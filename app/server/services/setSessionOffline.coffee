setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId}, done) ->
    setSessionOnlineStatus sessionId, false, (err) ->
      done err
