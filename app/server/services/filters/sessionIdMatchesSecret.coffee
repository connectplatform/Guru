db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['sessionSecret', 'sessionId']
  service: (args, next) ->
    {sessionSecret, sessionId} = args
    Session.findOne {secret: sessionSecret}, {_id: 1}, (err, session) ->
      errMsg = 'sessionId and sessionSecret must belong to same Session'
      return next errMsg unless sessionId == session._id
      next null, args