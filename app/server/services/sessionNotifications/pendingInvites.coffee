stoic = require 'stoic'
{Session, ChatSession} = stoic.models

filterChats = config.require 'services/operator/filterChats'

module.exports = (sessionId, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).getBySession sessionId, (err, chats) ->
      filterChats chats, ['invite', 'transfer'], (err, chats) ->
        message = chats
        event = 'pendingInvites'
        done err, event, message
