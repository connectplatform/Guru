module.exports = (res, fields) ->
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?
    #add to redis here, use return value of login for cookieo
    redisFactory = require '../../redis'
    redisFactory (redis)->
      redis.operators.login user.id, (id)->
        res.cookie 'session', id
        res.send null, user