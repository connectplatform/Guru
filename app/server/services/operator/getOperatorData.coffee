db = config.require 'load/mongo'
{Session, User} = db.models

# Internal helper service
module.exports = (sessionId, done) ->
  Session.findById sessionId, (err, session) ->
    return done err if err
    return done (new Error 'Session not found') if not session?
    
    User.findById session.userId, done
