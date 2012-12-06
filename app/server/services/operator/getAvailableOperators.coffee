async = require 'async'
stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User, Website, Specialty} = db.models

enums = config.require 'load/enums'

module.exports =
  required: ['websiteId']
  optional: ['specialty']
  service: ({websiteId, specialty}, done) ->

    accountInGoodStanding = config.service 'recurly/accountInGoodStanding'

    # get accountId.  TODO: refactor this to use required arg
    Website.findOne {_id: websiteId}, {accountId: true}, (err, website) ->
      config.log.warn 'website err:', {error: err} if err
      return done null, {operators: []} unless website # No relevant operators
      {accountId} = website

      accountInGoodStanding {accountId: accountId}, (err, goodStanding) ->
        return done null, {accountId: accountId, operators: []} if err or not goodStanding

        # get a list of operator sessions
        Session(accountId).onlineOperators.all (err, sessions) ->

          # go no further if we can't find any sessions
          return done err, {accountId: accountId, operators: []} if err or sessions.length is 0

          # get required data from each session
          getSessionData = (sess, next) ->
            sess.operatorId.get (err, opId) ->
              next null, {sessionId: sess.id, operatorId: opId}

          Specialty.findOne {name: specialty}, {_id: true}, (err, result) ->
            return next err if err
            specialtyId = result?._id

            async.map sessions, getSessionData, (err, opSessions) ->

              # build query to look for matching operators
              opIds = opSessions.map (o) -> o.operatorId
              query =
                _id: $in: opIds
                accountId: accountId
                $or: [role: $in: enums.managerRoles]

              route =
                websites: websiteId
              route.specialties = specialtyId if specialtyId

              query['$or'].push route

              # filter based on operator website/specialty
              User.find query, (err, users) ->
                return done err if err?
                uids = users.map (u) -> u._id.toString()
                available = opSessions.filter (o) -> o.operatorId in uids
                done null, {accountId: accountId, operators: available} # [{sessionId, operatorId}]
