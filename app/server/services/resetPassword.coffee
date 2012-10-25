{digest_s} = require 'md5'

db = config.require 'load/mongo'
{User} = db.models
{ObjectId} = db.Schema.Types

module.exports = ({userId, registrationKey, newPassword}, done) ->
  return done 'Invalid user or registration key.' unless userId and registrationKey
  return done 'Invalid password.' unless newPassword
  return done 'Password must be at least 6 characters.' if newPassword.length < 6

  User.findOne {_id: userId, registrationKey: registrationKey}, (err, user) ->
    if err? or not user?
      return done 'Could not find user or registration key.'

    user.password = digest_s newPassword
    user.registrationKey = null
    user.save (err) ->
      config.log.error 'Error saving new password in resetPassword', {error: err, userId: userId, registrationKey: registrationKey} if err
      done err
