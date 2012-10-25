setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

module.exports = ({sessionId}, done) ->
  setSessionOnlineStatus sessionId, false, (err) ->
    done err
