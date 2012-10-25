db = config.require 'load/mongo'
{Role} = db.models

module.exports = ({}, done) ->
  Role.find {}, (err, roles) ->
    done err, (role.name for role in roles)
