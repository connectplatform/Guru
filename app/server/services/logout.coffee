db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  # required: ['accountId', 'sessionId']
  # service: ({accountId, sessionId}, cb) ->
  required: ['sessionId']
  service: ({sessionId}, cb) ->
    # Session.findOneAndRemove {_id: sessionId}, (err, session) ->
    #   config.log.error 'Error logging out.', {error: err, sessionSecret: sessionSecret} if err
    #   cb err, {sessionId: null}
    Session.findById sessionId, (err, session) ->
      session.remove (err) ->
        config.log.error 'Error logging out.', {error: err, sessionSecret: sessionSecret} if err
        cb err, {sessionId: null}
