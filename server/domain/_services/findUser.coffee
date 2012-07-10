module.exports = (res, queryObject) ->
  db = require '../../mongo'
  {User} = db.models

  filterUser = (user) ->
    newUser = {id: user['_id']}
    newUser[key] = value for key, value of user._doc when key isnt 'password' and key isnt '_id'
    newUser

  User.find queryObject, (err, users) ->
    filteredUsers = (filterUser user for user in users)
    res.send err, filteredUsers