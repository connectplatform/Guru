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
