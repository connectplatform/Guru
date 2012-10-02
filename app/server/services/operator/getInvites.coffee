async = require 'async'
{tandoor, compact} = config.require 'load/util'

stoic = require 'stoic'
{ChatSession} = stoic.models

getInvites = (rel, next) ->
  rel.relationMeta.get 'type', (err, type) ->
    if type in ['invite', 'transfer']
      next null, {chatId: rel.chatId, type: type}
    else
      next()

module.exports = tandoor (sessionId, done) ->
  ChatSession.getBySession sessionId, (err, chatSessions) ->
    async.map chatSessions, getInvites, (err, chats) ->
      chats = compact chats if chats?
      done err, chats
