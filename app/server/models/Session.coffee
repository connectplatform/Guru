db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

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

session.statics.sessionByOperator = (userId, done) ->
  @.findOne {userId}, (err, sess) ->
    done err, sess

module.exports = session