module.exports = (res, fields) ->
  redis = require '../../redis'
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?
    redis.sessions.create 'operator', user.id, (id)->
      username = if user.lastName? then "#{user.firstName} #{user.lastName}" else "#{user.firstName}"
      redis.sessions.setChatName id, username, ->
        res.cookie 'session', id
        res.send null, user