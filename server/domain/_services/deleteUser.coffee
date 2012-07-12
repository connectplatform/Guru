module.exports = (res, id) ->
  db = require '../../mongo'
  {User} = db.models

  User.findOne {_id: id}, (err, user) ->
    return res.send err, null if err?

    user.remove (err) ->
      return res.send err, null if err?
      res.send null, "User removed"