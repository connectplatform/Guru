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
    return res.reply err.message if err?
    return res.reply 'Invalid user or password.' unless user?

    Session.sessionIdsByOperator.get user.id, (err, sessionId) ->
      if sessionId?
        res.cookie 'session', sessionId
        res.reply null, user
      else
        createUserSession user, (err, session) ->
          res.cookie 'session', session.id
          res.reply null, user
