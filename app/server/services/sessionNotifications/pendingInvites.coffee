stoic = require 'stoic'
{ChatSession} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports =
  required: ['sessionId', 'accountId']
  service: ({sessionId, accountId}, done) ->
    ChatSession(accountId).getBySession sessionId, (err, chats=[]) ->
      filterChats chats, ['invite', 'transfer'], (err, chats) ->
        message = chats
        event = 'pendingInvites'
        done err, {event: event, message: message}
