async = require 'async'
stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User, Website} = db.models

module.exports = (websiteId, specialty, done) ->

  Website.findOne {_id: websiteId, accountId: true}, (err, website) ->
    config.log.warn 'website err:', {error: err} if err
    return done "Could not find website: #{websiteId}" unless website
    {accountId} = website

    # get a list of operator sessions
    Session.onlineOperators.all (err, sessions) ->

      # go no further if we can't find any sessions
      return done err, sessions if err or sessions.length is 0

      # get required data from each session
      getSessionData = (sess, next) ->
        sess.operatorId.get (err, opId) ->
          next null, {sessionId: sess.id, operatorId: opId}

      async.map sessions, getSessionData, (err, opSessions) ->

        # build query to look for matching operators
        opIds = opSessions.map (o) -> o.operatorId
        query =
          _id: $in: opIds
          accountId: accountId
          $or: [role: 'Administrator']

        route =
          websites: websiteId
        route.specialties = new RegExp "^#{specialty}$", 'i' if specialty

        query['$or'].push route

        # filter based on operator website/specialty
        User.find query, (err, users) ->
          return done err if err?
          uids = users.map (u) -> u._id.toString()
          available = opSessions.filter (o) -> o.operatorId in uids
          done null, available # [{sessionId, operatorId}]
