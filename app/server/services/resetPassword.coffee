db = config.require 'load/mongo'
{User} = db.models
{ObjectId} = db.Schema.Types

module.exports =
  required: ['userId', 'registrationKey', 'newPassword']
  service: ({userId, registrationKey, newPassword}, done) ->
    User.findOne {_id: userId, registrationKey: registrationKey}, (err, user) ->
      if err? or not user?
        return done 'Could not find user or registration key.'

      user.password = newPassword
      user.registrationKey = null
      user.save (err) ->
        config.log.error 'Error saving new password in resetPassword', {error: err, userId: userId, registrationKey: registrationKey} if err
        done err
