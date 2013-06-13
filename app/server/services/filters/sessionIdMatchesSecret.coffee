db = config.require 'load/mongo'
{Session} = db.models

# This check runs _before_ the SessionId lookup defined in the jargon file.
# Its purpose is to ensure that if a service caller provides both a
# sessionSecret and a sessionId, they belong to the _same_ Session. If this
# constraint weren't enforced, any given sessionSecret would be sufficient
# caller credentials to treat the passed sessionId as the caller's own. If
# no sessionId is passed, it will be obtained later in the Law chain via a
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
        resultErr = new Error 'sessionId and sessionSecret must belong to same Session'
        
      next resultErr