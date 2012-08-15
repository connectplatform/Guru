redgoose = require 'redgoose'
{digest_s} = require 'md5'
db = require '../../mongo'
{User} = db.models

module.exports = (res, fields) ->
  console.log "entered login"
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?

    username = if user.lastName is not "" then "#{user.firstName} #{user.lastName}" else "#{user.firstName}"

    {Session} = redgoose.models
    Session.sessionIdsByOperator.get user.id, (err, sessionId) ->
      console.log "error getting existing session" if err
      if sessionId?
        res.cookie 'session', sessionId
        console.log "sending back existing session"
        res.send null, user
      else
        Session.create {role: user.role, chatName: username, operatorId: user.id}, (err, session) ->
          res.cookie 'session', session.id
          console.log "making new session"
          res.send null, user
