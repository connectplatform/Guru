stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, done) ->
  return done "SessionId required." unless sessionId
  Session.accountLookup.get sessionId done
