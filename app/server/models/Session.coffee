db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
enums = config.require 'load/enums'
{random, getString} = config.require 'load/util'

# Session for a logged-in User or non-User visitor
session = new Schema

  accountId:
    type: ObjectId
    required: true

  userId: ObjectId

  username:
    type: String
    required: true

  online:
    type: Boolean
    default: true

  secret:
    type: String
    default: random

  unansweredChats:
    type: [String]
    default: []

  unreadMessages:
    type: Number
    default: 0

# return string, not ObjectId
for field in ['_id', 'accountId', 'userId']
  session.path(field).get getString

session.statics.sessionByOperator = (userId, done) ->
  @.findOne {userId}, (err, sess) ->
    done err, sess

session.post 'remove', (_session) ->
  {ChatSession} = db.models
  sessionId = _session._id
  ChatSession.remove {sessionId}, (err) ->
    if err?
      config.log.error 'Error cascading remove', {error: err, sessionId: sessionId}

module.exports = session