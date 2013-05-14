# This used to be used by logout.  We destroy the session now on logout.
# I'm not sure if it will be relevant going forward.
db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionId']
  service: ({sessionId}, done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'
    setSessionOnlineStatus {sessionId: sessionId, isOnline: false}, (err) ->
      done err
