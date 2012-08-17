redgoose = require 'redgoose'
{digest_s} = require 'md5'
db = require '../../mongo'
{User} = db.models

module.exports = (res, fields) ->
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.reply err.message if err?
    return res.reply 'Invalid user or password.' unless user?

    username = if user.lastName is not "" then "#{user.firstName} #{user.lastName}" else "#{user.firstName}"

    {Session} = redgoose.models
    Session.sessionIdsByOperator.get user.id, (err, sessionId) ->
      if sessionId?
        res.cookie 'session', sessionId
        res.reply null, user
      else
        Session.create {role: user.role, chatName: username, operatorId: user.id}, (err, session) ->
          res.cookie 'session', session.id
          res.reply null, user
