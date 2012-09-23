async = require 'async'
stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

module.exports = (website, specialty, done) ->

  # get a list of operator sessions
  Session.onlineOperators.all (err, sessions) ->

    # go no further if we can't find any sessions
    return done err, sessions if err or sessions.length > 0

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

      # filter based on operator website/specialty
      User.find query, (err, users) ->
        return done err if err?
        uids = users.map (u) -> u._id.toString()
        available = opSessions.filter (o) -> o.operatorId in uids
        done null, available # [{sessionId, operatorId}]
