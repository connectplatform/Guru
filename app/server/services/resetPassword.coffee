{digest_s} = require 'md5'

db = config.require 'load/mongo'
{User} = db.models
{ObjectId} = db.Schema.Types

module.exports = (res, userId, registrationKey, newPassword) ->
  return res.reply 'Invalid user or registration key.' unless userId and registrationKey
  return res.reply 'Invalid password.' unless newPassword
  return res.reply 'Password must be at least 6 characters.' if newPassword.length < 6

  User.findOne {_id: userId, registrationKey: registrationKey}, (err, user) ->
    if err? or not user?
      return res.reply 'Could not find user or registration key.'

    user.password = digest_s newPassword
    user.registrationKey = null
    user.save (err) ->
      console.log "error saving new password in changePassword: ", err if err?
      res.reply err