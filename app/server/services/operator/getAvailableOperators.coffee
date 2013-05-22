async = require 'async'

db = config.require 'load/mongo'
{Session, User, Website, Specialty} = db.models

enums = config.require 'load/enums'

module.exports =
  required: ['websiteId', 'accountId']
  optional: ['specialtyId']
  service: ({websiteId, specialtyId}, done) ->

    accountInGoodStanding = config.service 'recurly/accountInGoodStanding'

    # get accountId.  TODO: refactor this to use required arg
    Website.findById websiteId, {accountId: true}, (err, website) ->
      config.log.warn 'website err:', {error: err} if err
      return done null, {operators: [], reason: "Can't find website."} unless website
      {accountId} = website

      accountInGoodStanding {accountId: accountId}, (err, {goodStanding}) ->
        return done err, {accountId: accountId, operators: [], reason: 'Account not in good standing.'} if err or not goodStanding

        # get a list of operator sessions
        Session.find {accountId: accountId, userId: {'$ne': null}}, (err, sessions) ->
          # go no further if we can't find any sessions
          return done err, {accountId: accountId, operators: [], reason: 'No relevant operators logged in.'} if err or sessions.length is 0

          # We want all the Users who:
          # Are active, thus..
          # .. have a user._id == session.userId for some session
          operatorIds = sessions.map((s) -> s.userId)
          # EITHER have the salient website and specialty qualifications, thus..
          # .. have websiteId in user.websites AND
          # .. have specialtyId in user.specialties
          cond1 =
            websites: websiteId  # shorthand for {'$elemMatch': {'$eq': websiteId}}
            specialties: specialtyId
          # OR are a manager
          cond2 =
            role: {'$in': enums.managerRoles}  # user.role in enums.managerRoles
          query = User.find().where('_id').in(operatorIds).or [cond1, cond2]
          query.exec (err, users) ->
            done null, {accountId: accountId, operators: users} # [{sessionId, operatorId}]
