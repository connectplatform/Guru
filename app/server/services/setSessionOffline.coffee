# This used to be used by logout.  We destroy the session now on logout.
# I'm not sure if it will be relevant going forward.
db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret']
  service: ({sessionSecret}, done) ->
    setSessionOnlineStatus = config.service 'session/setSessionOnlineStatus'
    setSessionOnlineStatus {sessionSecret: sessionSecret, isOnline: false}, (err) ->
      done err
