module.exports = (args, next) ->
  setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'
  setSessionOnlineStatus {sessionId: args.sessionId, isOnline: true}, ->
    next null, args
