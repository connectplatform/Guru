filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  filterChats sessionId, ['invite', 'transfer'], (err, chats) ->
    message = chats
    event = 'pendingInvites'
    done err, event, message
