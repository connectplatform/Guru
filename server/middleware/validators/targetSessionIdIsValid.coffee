redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (args, cookies, cb) ->
  [_, sessionId]= args
  return cb 'expects valid session id as second argument' unless sessionId?

  Session.allSessions.ismember sessionId, (err, sessionExists) ->
    return cb 'invalid or expired session Id' unless sessionExists is 1
    cb()
