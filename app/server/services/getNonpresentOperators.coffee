async = require 'async'
db = config.require 'load/mongo'
{ChatSession, Session, User} = db.models

{getType} = config.require 'load/util'

module.exports =
  required: ['chatId', 'sessionSecret']
  service: ({chatId, sessionId, accountId}, done) ->
    # First, find all ChatSession connecting some active Session to the Chat
    # denoted by chatId in which the connected
    ChatSession.find {chatId, relation: 'Member'}, (err, chatSessions) ->
    # ChatSession.find {chatId, relation: '$in': ['Member','Watching']}, (err, chatSessions) ->
      done err, null if err

      sessionIdsToExclude = (cs.sessionId for cs in chatSessions)

      Session.find {_id: {'$nin': sessionIdsToExclude}, accountId}, (err, sessions) ->
        operatorSessions = sessions.filter (s) -> (s.userId?)
        done err, {operators: operatorSessions}
