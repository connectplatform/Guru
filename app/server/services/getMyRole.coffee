db = config.require 'load/mongo'
{Session, User} = db.models

module.exports =
  optional: ['sessionId']
  service: ({sessionId}, done) ->
    return done null, {role: 'None'} unless sessionId

    Session.findById sessionId, (err, session) ->
      User.findById session.userId, (err, user) ->
        done err, {role: user.role}
