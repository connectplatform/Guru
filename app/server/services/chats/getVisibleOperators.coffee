# this service could be far more useful if it
# 1) took args in a standard format
# 2) accepted chatId instead of chatSessions
# 3) returned more information (IDs?)

async = require 'async'

db = config.require 'load/mongo'
{ChatSession, Session, User} = db.models

module.exports = (chatId, cb) ->
  ChatSession.find {chatId, relation: 'Member'}, (err, chatSessions) ->
    done err, null if err
    cond =
      userId: '$ne': null
      _id: '$in': (cs.sessionId for cs in chatSessions)
      
    Session.find cond, (err, sessions) ->
      done err, null if err

      userIds = (s.userId for s in sessions)
      User.find {_id: '$in': (s.userId for s in sessions)}, cb
        
  # nullOutNonvisibleOperators = (chatSession, cb) ->
    
    
  #   # TODO: Add chatSession.dump
  #   async.parallel [
  #     chatSession.relationMeta.get 'isWatching'
  #     chatSession.session.role.get
  #     chatSession.session.chatName.get

  #   ], (err, [isWatching, role, chatName]) ->

  #     if isWatching is 'true' or role is 'Visitor'
  #       value = null
  #     else
  #       value = chatName

  #     cb err, value

  # async.map chatSessions, nullOutNonvisibleOperators, (err, visibleOperators) ->
  #   cb err, visibleOperators.filter (element) -> element != null
