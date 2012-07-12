module.exports = (res, fields) ->
  {digest_s} = require 'md5'
  db = require '../../mongo'
  {User} = db.models

  getUser = (fields, cb) ->
    if fields.id?
      User.findOne {_id: fields.id}, (err, user) ->
        return res.send err, null if err?
        cb user
    else
      #TODO: generate a random password that we can email to the user
      user = new User
      user.password = digest_s 'password'
      cb user

  getUser fields, (user) ->   
    user[key] = value for key, value of fields when key isnt 'id'
    user.save (err) ->
      console.log "error saving user model: #{err}" if err?

      filterUser = (user) ->
        newUser = {id: user['_id']}
        newUser[key] = value for key, value of user._doc when key isnt 'password' and key isnt '_id'
        newUser

      res.send err, filterUser user
