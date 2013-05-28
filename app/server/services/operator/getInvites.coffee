async = require 'async'
{tandoor} = config.require 'load/util'

db = config.require 'load/mongo'
{Session, ChatSession} = db.models

# getInvites = (rel, next) ->
#   rel.relationMeta.get 'type', (err, type) ->
#     if type in ['invite', 'transfer']
#       next null, {chatId: rel.chatId, type: type}
#     else
#       next()

module.exports = tandoor (sessionId, done) ->
  Session.findById sessionId, (err, session) ->
    cond =
      sessionId: sessionId
      relation: '$in': ['Invite', 'Transfer']
    ChatSession.find cond, done
    
  # Session.accountLookup.get sessionId, (err, accountId) ->
  #   ChatSession(accountId).getBySession sessionId, (err, chatSessions) ->
  #     async.map chatSessions, getInvites, (err, chats) ->
  #       chats = chats.compact() if chats?
  #       done err, chats
