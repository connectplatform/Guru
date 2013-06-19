db = config.require 'load/mongo'
{Session} = db.models

# This check runs _before_ the SessionId lookup defined in the jargon file.
# Its purpose is to prevent malicious modification of another user's data by
# supplying a sessionSecret and sessionId that do not match.
# If no sessionId is passed, it will be obtained later in the Law chain via a
# lookup on sessionSecret, in which case the constraint will satisfied
# naturally by the nature of the lookup.
module.exports =
  optional: ['sessionSecret', 'sessionId']
  service: ({sessionSecret, sessionId}, next) ->
    return next() unless sessionSecret and sessionId

    Session.findOne {secret: sessionSecret}, {_id: 1}, (err, session) ->
      if sessionId is session._id
        resultErr = null
      else
        resultErr = new Error 'sessionId and sessionSecret must belong to same Session.'

      next resultErr
