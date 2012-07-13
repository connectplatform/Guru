module.exports = (res) ->
  db = require '../../mongo'
  {Role} = db.models

  Role.find {}, (err, roles) ->
    res.send err, (role.name for role in roles)