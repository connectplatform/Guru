stoic = require 'stoic'
{Session} = stoic.models

db = require 'mongoose'
{User} = db.models

module.exports = (sessionId, done) ->
  return done "SessionId required." unless sessionId
  Session.get(sessionId).operatorId.get (err, opId) ->
    User.findById opId, {accountId: true}, (err, user) ->
      done err, user?.accountId
