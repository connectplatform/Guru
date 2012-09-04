stoic = require 'stoic'
{Session} = stoic.models

module.exports = (args, cookies, cb) ->

  sessionId = cookies.session
  return cb "expected cookie: {session: sessionId}" unless sessionId?

  Session.get(sessionId).role.get (err, role) ->
    return cb "You are not an administrator" unless role is "Administrator"
    cb()
