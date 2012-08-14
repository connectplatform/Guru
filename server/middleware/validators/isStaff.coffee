redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (args, cookies, cb) ->
  sessionId = cookies.session
  return cb "expected cookie: {session: sessionId}" unless sessionId?

  Session.get(sessionId).role.get (err, role) ->
    unless (role is "Administrator") or (role is "Supervisor") or (role is "Operator")
      return cb "You are not a registered user"
    cb()
