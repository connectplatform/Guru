db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['accountId', '_id']
  service: (user, done) ->
    {accountId} = user
    createUserSession = config.service 'operator/createUserSession'
    
    Session.findOne {userId: user._id}, (err, session) ->
      if err
        config.log.warn 'Error getting operator session.', {error: err, userId: user._id} if err
        return done err
        
      if session?
        session.online = true
        session.save (err, session) ->
          if err
            meta = {error: err, sessionId: session._id}
            config.log.error 'Error setting operator online status.', meta
            return done err
            
          return done err, {sessionSecret: session.secret}
      else
        createUserSession user, (err, session) ->
          config.log.warn 'Error creating user session.', {error: err, userId: user._id} if err
          return done err, {sessionSecret: session.secret}
