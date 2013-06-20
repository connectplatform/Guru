db = config.require 'load/mongo'
{ChatSession, Session, User} = db.models

{getType} = config.require 'lib/util'

module.exports =
  required: ['sessionSecret', 'sessionId', 'chatId', 'accountId']
  service: ({chatId, sessionId, accountId}, done) ->
    # First, find all ChatSession connecting some active Session to the Chat
    # denoted by chatId in which the connected
    ChatSession.find {chatId, relation: 'Member'}, (err, chatSessions) ->
      return done err if err

      sessionIdsToExclude = (cs.sessionId for cs in chatSessions)

      Session.find {_id: {'$nin': sessionIdsToExclude}, accountId}, (err, sessions) ->
        return done err if err

        operatorSessions = sessions?.filter (s) -> (s.userId?)
        done err, {operators: operatorSessions}
