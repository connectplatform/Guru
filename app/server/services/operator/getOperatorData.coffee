stoic = config.require 'load/initStoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (sessionId, done) ->
  Session.get(sessionId).operatorId.get (err, opId) ->
    User.findById opId, done
