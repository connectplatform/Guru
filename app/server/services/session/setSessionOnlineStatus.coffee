db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionId', 'isOnline']
  service: ({sessionId, isOnline}, cb) ->
    Session.findById sessionId, (err, session) ->
      session.online = isOnline
      session.save (err) ->
        config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionId: sessionId} if err
        cb err
