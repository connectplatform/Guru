stoic = require 'stoic'
{ChatSession} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  ChatSession.getBySession sessionId, (err, chats) ->
    filterChats chats, ['invite', 'transfer'], (err, chats) ->
      message = chats
      event = 'pendingInvites'
      done err, event, message
