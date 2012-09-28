stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, cb) ->
  Session.allSessions.ismember sessionId, (err, sessionExists) ->
    return cb('invalid or expired session Id') unless sessionExists is 1
    cb()
