require '../app/config'
db = config.require 'load/mongo'
{User} = db.models

email = process.argv[2]
process.exit 'no email' unless email

User.findOne {email: email}, (err, user) ->
  console.log 'Error finding user:', err if err?

  user.sentEmail = false
  user.save (err, user) ->
    console.log 'Error saving user:', err if err?
    process.exit()
