db = config.require 'load/mongo'
{Session, User} = db.models

module.exports =
  optional: ['sessionSecret']
  service: ({sessionSecret}, done) ->
    return done null, {role: 'None'} unless sessionSecret?
    
    Session.findOne {secret: sessionSecret}, (err, session) ->
      return done err if err
      return done null, {role: 'None'} unless session
      
      User.findById session.userId, (err, user) ->
        return done err if err

        if user?
          return done err, {role: user.role}
        else
          return done err, {role: 'Visitor'}
