db = config.require 'load/mongo'
{User} = db.models

module.exports = ({email}, done) ->
  User.findOne {email: email}, (err, user) ->

    if err or not user?
      return done "Could not find user."

    else
      user.sentEmail = false
      user.save()
      return done null, {result: "sentEmail", email: email}
