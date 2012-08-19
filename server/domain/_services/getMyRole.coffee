stoic = require 'stoic'
{Session} = stoic.models

module.exports = (res) ->
  sessionId = res.cookie 'session'
  return res.reply null, 'None' unless sessionId?
  Session.get(sessionId).role.get res.reply
