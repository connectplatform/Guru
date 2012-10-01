setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

module.exports = (res, sessionId) ->
  setSessionOnlineStatus sessionId, false, (err) ->
    res.reply err
