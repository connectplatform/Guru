stoic = require 'stoic'
{Session} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  session = Session.get(sessionId)
  session.unansweredChats.count (err, chatCount) ->
    message = {count: chatCount}
    event = 'unansweredChats'
    done err, event, message
