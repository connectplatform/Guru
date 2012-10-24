{digest_s} = require 'md5'

stoic = require 'stoic'
{Session} = stoic.models

db = config.require 'load/mongo'
{User} = db.models

createUserSession = config.require 'services/operator/createUserSession'

module.exports = (res, fields) ->
  return res.reply 'Invalid user or password.' unless fields.email and fields.password
  search = {email: fields.email, password: digest_s fields.password}
  User.findOne search, (err, user) ->
    if err
      config.log.error 'Error searching for operator in login', {error: err, email: fields.email} if err
      return res.reply err.message
    return res.reply 'Invalid user or password.' unless user?

    accountId = user.accountId.toString()
    Session(accountId).sessionsByOperator.get user.id, (err, sessionId) ->
      config.log.warn 'Error getting operator session in login', {error: err, userId: user.id} if err
      if sessionId?
        Session(accountId).get(sessionId).online.set true, (err) ->
          config.log.error 'Error setting operator online status when reconnecting to session', {error: err, sessionId: sessionId} if err
          res.cookie 'session', sessionId
          res.reply null, user
      else
        createUserSession user, (err, session) ->
          res.cookie 'session', session.id
          res.reply null, user
