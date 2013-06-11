db = config.require 'load/mongo'
{Session, User} = db.models

getOperatorData = config.require 'services/operator/getOperatorData'

module.exports =
  required: ['oldPassword', 'newPassword', 'sessionSecret']
  service: ({oldPassword, newPassword, sessionId}, done) ->
    getOperatorData sessionId, (err, user) ->
      config.log.error 'Error getting user from sessionId in changePassword', {error: err, sessionId: sessionId} if err
      return done "User not found." unless user
      return done "Incorrect current password." unless user.comparePassword oldPassword
      return done 'Invalid password.' unless newPassword
      return done 'New password must be at least 6 characters.' if newPassword.length < 6

      user.password = newPassword
      user.save (err) ->
        config.log.error "Error saving new password in changePassword: ", {error: err, user: user} if err
        done err
