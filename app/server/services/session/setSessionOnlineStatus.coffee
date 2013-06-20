db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret', 'isOnline']
  service: ({sessionSecret, isOnline}, cb) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err if err
      return done (new Error 'Session not found') if not session

      session?.online = isOnline
      session?.save (err) ->
        config.log.error 'Error setting session status in setSessionOnlineStatus', {error: err, sessionSecret: sessionSecret} if err
        cb err
