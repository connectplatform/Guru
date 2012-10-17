db = config.require 'load/mongo'
{User} = db.models

module.exports = (email) ->
  unless email
    console.log 'no email'
    process.exit()

  User.findOne {email: email}, (err, user) ->
    if err? or not user
      console.log 'Error finding user:', err
      process.exit()

    user.sentEmail = false
    user.save (err, user) ->
      console.log 'Error saving user:', err if err?
      process.exit()
