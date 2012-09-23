stoic = require 'stoic'
{Session} = stoic.models

module.exports = (res, sessionId) ->
  console.log 'sessionId in logout: ', sessionId

  Session.get(sessionId).online.set false, (err) ->
    console.log 'Error setting session status to offline: ', err if err?
    res.reply err
    console.log 'reply was sent from logout'
