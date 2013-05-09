async = require 'async'
{tandoor} = config.require 'load/util'

# stoic = require 'stoic'
# {Session, ChatSession} = stoic.models

getInvites = (rel, next) ->
  rel.relationMeta.get 'type', (err, type) ->
    if type in ['invite', 'transfer']
      next null, {chatId: rel.chatId, type: type}
    else
      next()

module.exports = tandoor (sessionId, done) ->
  Session.accountLookup.get sessionId, (err, accountId) ->
    ChatSession(accountId).getBySession sessionId, (err, chatSessions) ->
      async.map chatSessions, getInvites, (err, chats) ->
        chats = chats.compact() if chats?
        done err, chats
