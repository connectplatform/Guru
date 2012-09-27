stoic = require 'stoic'
{Session} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  Session.unansweredChats.count (chatCount) ->
    message = {count: chatCount}
    event = 'unansweredChats'
    done err, event, message
