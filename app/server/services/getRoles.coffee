db = config.require 'load/mongo'
{Role} = db.models

enums = config.require 'load/enums'

module.exports = (args, done) ->
  done null, enums.staffRoles
