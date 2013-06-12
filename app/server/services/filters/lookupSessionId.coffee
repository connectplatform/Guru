db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret']
  service: ({sessionSecret, sessionId}, found) ->
    return found null, {sessionId} if sessionId
    
    Session.findOne {secret: sessionSecret}, (err, session) ->
      found err if err or not session

      found err, {sessionId: session?._id}

      