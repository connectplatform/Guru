stoic = require 'stoic'
{Session} = stoic.models
db = require '../../mongo'
{User} = db.models
{digest_s} = require 'md5'

getUserFromSessionId = (sessionId, cb) ->
  Session.get(sessionId).operatorId.get (err, operatorId) ->
    console.log "error retrieving operatorId from redis in changePassword: ", err if err
    User.findOne {_id: operatorId}, (err, user) ->
      console.log "error retrieving user from mongo in changePassword: ", err if err
      cb null, user


module.exports = (res, oldPassword, newPassword) ->
  getUserFromSessionId res.cookie("session"), (err, user) ->
    return res.reply "user not found" unless user
    return res.reply "invalid password" unless user.password is digest_s oldPassword
    user.password = digest_s newPassword
    user.save (err) ->
      console.log "error saving new password in changePassword: ", err if err
      res.reply err
