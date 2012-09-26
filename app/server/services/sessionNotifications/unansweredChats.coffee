stoic = require 'stoic'
{ChatSession} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  ChatSession.getBySession sessionId, (err, chats) ->
    filterChats chats, 'new', (err, chats) ->
      message = {count: chats.length}
      event = 'unansweredChats'
      done err, event, message
