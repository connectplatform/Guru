db = config.require 'load/mongo'
{Session, User} = db.models

module.exports =
  optional: ['sessionId']
  service: ({sessionId}, done) ->
    if sessionId?
      Session.findById sessionId, (err, session) ->
        User.findById session.userId, (err, user) ->
          console.log {err, user}
          if user?
            done err, {role: user.role}
          else
            done err, {role: 'Visitor'}
    else
      return done null, {role: 'None'}
