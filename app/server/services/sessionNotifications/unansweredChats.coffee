filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  filterChats sessionId, 'new', (err, chats) ->
    message = {count: chats.length}
    event = 'unansweredChats'
    done err, event, message
