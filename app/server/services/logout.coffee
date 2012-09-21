stoic = require 'stoic'
{Session} = stoic.models

module.exports = (res) ->
  sessionId = res.cookie 'session'

  Session.get(sessionId).online.set false, (err) ->
    console.log 'Error setting session status to offline: ', err if err?
    res.reply err
