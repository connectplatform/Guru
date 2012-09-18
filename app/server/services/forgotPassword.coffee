db = config.require 'load/mongo'
{User} = db.models

module.exports = (res, email) ->
  User.findOne {email: email}, (err, user) ->
    if err? or not email?
      return res.reply "Could not find user."

    else
      user.sentEmail = false
      user.save()
      return res.reply null, "Success! Please check your email for reset instructions."
