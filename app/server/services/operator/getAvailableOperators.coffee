stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (website, specialty, next) ->
  Session.onlineOperators.all (err, ops) ->

