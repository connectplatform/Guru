db = require '../../mongo'
{Role} = db.models

module.exports = (res) ->
  Role.find {}, (err, roles) ->
    res.send err, (role.name for role in roles)
