{digest_s} = require 'MD5'
db = require '../../mongo'
{User} = db.models

module.exports = (res, fields) ->
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?
    res.cookie 'login', user.id
    res.send null, user
