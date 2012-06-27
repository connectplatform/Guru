module.exports = (res, fields) ->
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    return res.send err.message if err?
    return res.send 'Invalid user or password.' unless user?
    res.cookie 'login', user.id
    res.send null, user
