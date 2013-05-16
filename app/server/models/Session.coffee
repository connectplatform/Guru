db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
enums = config.require 'load/enums'
{random} = config.require 'load/util'

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