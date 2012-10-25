setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

module.exports = (args, next) ->
  setSessionOnlineStatus args.sessionId, true, ->
    next null, args
