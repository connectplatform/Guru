db = config.require 'load/mongo'
{Session} = db.models

module.exports = (sessionId, done) ->
  return done "SessionId required." unless sessionId
  Session.findById sessionId, (err, session) ->
    
  Session.accountLookup.get sessionId, done
