module.exports = (res, fields) ->
  redgoose = require 'redgoose'
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models

  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?

    username = if user.lastName is not "" then "#{user.firstName} #{user.lastName}" else "#{user.firstName}"

    {Session} = redgoose.models
    Session.create {role: user.role, chatName: username}, (err, session) ->
      res.cookie 'session', session.id
      res.send null, user
