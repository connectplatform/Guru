stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (website, specialty, next) ->
  Session.onlineOperators.all (err, ops) ->

    query =
      _id: $in: ops.map (o) -> o.id
    query.website = website if website?
    query.specialty = specialty if specialty?

    User.find query, (err, users) ->
      uids = users.map (u) -> u._id
      available = ops.filter (o) -> o.id in uids
      next null, available
