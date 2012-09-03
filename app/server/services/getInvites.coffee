async = require 'async'
{tandoor, compact} = config.require 'load/util'

getInvites = (rel, next) ->
  rel.relationMeta.get 'type', (err, type) ->
    if type in ['invite', 'transfer']
      next null, {chatId: rel.chatId, type: type}
    else
      next()

# This takes a stoic model.  Not sure if I like that.
module.exports = tandoor (chatSession, done) ->
  chatSession.sessionIndex.members (err, chats) ->
    async.map chats, getInvites, (err, chats) ->
      chats = compact chats if chats?
      done err, chats
