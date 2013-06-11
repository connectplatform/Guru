db = config.require 'load/mongo'
{Session, User} = db.models

module.exports =
  optional: ['sessionSecret']
  service: ({sessionSecret}, done) ->
    if sessionSecret?
      Session.findOne {secret: sessionSecret}, (err, session) ->
        return done null, {role: 'None'} if err or not session

        User.findById session.userId, (err, user) ->
          if user?
            done err, {role: user.role}
          else
            done err, {role: 'Visitor'}
    else
      return done null, {role: 'None'}
