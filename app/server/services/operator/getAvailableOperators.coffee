stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (website, specialty, next) ->
  Session.onlineSessions.all (err, ops) ->

    query =
      _id: $in: ops
    query.website = website if website?
    query.specialty = specialty if specialty?

    User.find query, (err, users) ->
      ops.withUserIds users.map (u) -> u._id
