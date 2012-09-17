{digest_s} = require 'md5'

stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

getUserFromSessionId = (sessionId, cb) ->
  Session.get(sessionId).operatorId.get (err, operatorId) ->
    console.log "error retrieving operatorId from redis in changePassword: ", err if err
    User.findOne {_id: operatorId}, (err, user) ->
      console.log "error retrieving user from mongo in changePassword: ", err if err
      cb null, user


module.exports = (res, oldPassword, newPassword) ->
  getUserFromSessionId res.cookie("session"), (err, user) ->
    return res.reply "User not found." unless user
    return res.reply "Incorrect current password." unless user.password is digest_s oldPassword
    return res.reply 'Invalid password.' unless newPassword
    return res.reply 'New password must be at least 6 characters.' if newPassword.length < 6

    user.password = digest_s newPassword
    user.save (err) ->
      console.log "error saving new password in changePassword: ", err if err
      res.reply err
