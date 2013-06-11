db = config.require 'load/mongo'
{Session, User} = db.models

module.exports = (sessionId, done) ->
  Session.findById sessionId, (err, session) ->
    sessionId = session._id
    User.findById session.userId, done
