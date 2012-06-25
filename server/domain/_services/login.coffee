{digest_s} = require 'MD5'
db = require '../../mongo'
{User} = db.models

module.exports = (res, fields) ->
  User.findOne {email: fields.email, password: digest_s fields.password}, (err, result) ->
    return res.send err.message if err?
    [user] = result
    return res.send 'Invalid user or password.' unless user?
    res.cookie 'login', user.id
    res.send null, seeker
