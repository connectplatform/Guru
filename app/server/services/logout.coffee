db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId', 'accountId']
  service: ({sessionId}, cb) ->
    Session.findById sessionId, (err, session) ->
      session.remove (err) ->
        config.log.error 'Error logging out.', {error: err, sessionSecret: sessionSecret} if err
        cb err, {sessionId: null}
