module.exports = (res, fields) ->
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models

  if fields.id?
    #update model
    #TODO: this
  else
    #create new model
    user = new User
    #TODO: generate a random password that we can email to the user
    user.password = digest_s 'password'

  user[key] = value for key, value of fields when key isnt 'id'
  user.save (err) ->
    console.log "error saving user model: #{err}" if err?
    res.send err, user['_id']
