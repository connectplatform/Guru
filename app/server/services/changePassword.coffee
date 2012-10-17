{digest_s} = require 'md5'

stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

getUserFromSessionId = (sessionId, cb) ->
  Session.get(sessionId).operatorId.get (err, operatorId) ->
    config.log.error 'Error retrieving operatorId from redis in changePassword', {error: err, sessionId: sessionId} if err
    User.findOne {_id: operatorId}, (err, user) ->
      config.log.error 'Error retrieving user from mongo in changePassword', {error: err, operatorId: operatorId} if err
      cb null, user

module.exports = (res, oldPassword, newPassword) ->
  sessionId = res.cookie 'session'
  getUserFromSessionId sessionId, (err, user) ->
    config.log.error 'Error getting user from sessionId in changePassword', {error: err, sessionId: sessionId} if err
    return res.reply "User not found." unless user
    return res.reply "Incorrect current password." unless user.password is digest_s oldPassword
    return res.reply 'Invalid password.' unless newPassword
    return res.reply 'New password must be at least 6 characters.' if newPassword.length < 6

    user.password = digest_s newPassword
    user.save (err) ->
      config.log.error "Error saving new password in changePassword: ", {error: err, user: user} if err
      res.reply err
