stoic = require 'stoic'
{Session} = stoic.models

module.exports = (sessionId, isOnline, cb) ->
  Session.get(sessionId).online.set isOnline, (err) ->
    console.log 'Error setting session status to offline: ', err if err?
    cb err
