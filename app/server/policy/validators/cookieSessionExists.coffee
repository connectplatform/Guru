stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, cookies, cb) ->
  sessionId = cookies.session
  return cb 'expects cookie: {session: sessionId}' unless sessionId?

  Session.allSessions.ismember sessionId, (err, sessionExists) ->
    return cb 'invalid or expired session Id' unless sessionExists is 1
    cb()
