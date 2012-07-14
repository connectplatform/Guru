db = require '../../mongo'
{User} = db.models

filterUser = (user) ->
  newUser = {id: user['_id']} # watch out, this alias might bite us later on
  newUser[key] = value for key, value of user._doc when key isnt 'password' and key isnt '_id'
  return newUser

module.exports = (res, queryObject) ->
  User.find queryObject, (err, users) ->
    filteredUsers = (filterUser user for user in users)
    res.send err, filteredUsers
