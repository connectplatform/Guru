{digest_s} = require 'md5'

stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

createUserSession = config.require 'services/operator/createUserSession'

#TODO: implement as required param
#filters: ['firstArgumentIsObject']
#filters: ['loginObjectIsValid']
module.exports = ({email, password}, done) ->
  return done 'Invalid user or password.' unless email and password

  search = {email: email, password: digest_s password}
  User.findOne search, (err, user) ->
    if err
      config.log.error 'Error searching for operator in login', {error: err, email: email} if err
      return done err.message
    return done 'Invalid user or password.' unless user?

    accountId = user.accountId.toString()
    Session(accountId).sessionsByOperator.get user.id, (err, sessionId) ->
      config.log.warn 'Error getting operator session in login', {error: err, userId: user.id} if err
      if sessionId?
        Session(accountId).get(sessionId).online.set true, (err) ->
          if err
            meta = {error: err, sessionId: sessionId}
            config.log.error 'Error setting operator online status when reconnecting to session'

          done null, user, {setCookie: sessionId: sessionId}
      else
        createUserSession user, (err, session) ->
          done null, user, {setCookie: sessionId: session.id}
