stoic = require 'stoic'
{Session} = stoic.models

module.exports = (res) ->
  sessionId = res.cookie 'session'
  return res.reply null, 'None' unless sessionId?

  Session.accountLookup.get sessionId, (err, accountId) ->
    Session(accountId).get(sessionId).role.get (err, role) ->
      role ||= 'None'
      res.reply err, role
