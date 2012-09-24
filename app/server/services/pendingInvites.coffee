stoic = require 'stoic'
{Chat} = stoic.models

config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  Session.get(sessionId).unansweredChats.count (err, chatCount) ->
    message = {count: chatCount}
    event = 'unansweredChats'
    done err, event, message
