async = require 'async'
stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models
{ObjectId} = db.Schema.Types

module.exports = (website, specialty, next) ->

  # get a list of operator sessions
  Session.onlineOperators.all (err, sessions) ->

    # get required data from each session
    getSessionData = (sess, next) ->
      sess.operatorId.get (err, opId) ->
        next null, {sessionId: sess.id, operatorId: opId}

    async.map sessions, getSessionData, (err, opSessions) ->

      # look for matching operators
      opIds = opSessions.map (o) -> o.operatorId
      query =
        _id: $in: opIds
      query.websites = website if website
      query.specialties = specialty if specialty

      User.find query, (err, users) ->
        return next err if err?
        uids = users.map (u) -> u._id.toString()
        available = opSessions.filter (o) -> o.operatorId in uids
        next null, available
