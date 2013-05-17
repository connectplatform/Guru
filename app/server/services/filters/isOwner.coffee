db = config.require 'load/mongo'
{Session, User} = db.models

module.exports = (args, next) ->
  {sessionId} = args
  return next 'Argument Required: {session: sessionId}' unless sessionId?

  Session.findById sessionId, (err, session) ->
    User.findById session.userId, (err, user) ->
      errMsg = 'You must be an account Owner to access this feature.'
      return next errMsg unless user.role is 'Owner'
      next null, args
