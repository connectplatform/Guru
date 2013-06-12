db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret']
  service: ({sessionSecret, sessionId}, found) ->
    # return found null, {sessionId} if sessionId
    
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return found err if err or not session?
      return found err, {sessionId: session?._id}

      