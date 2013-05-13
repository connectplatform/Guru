db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
enums = config.require 'load/enums'

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

  role:
    type: String
    enum: enums.staffRoles

session.statics.sessionByOperator = (userId, done) ->
  @.findOne {userId}, (err, sess) ->
    done err, sess
module.exports = session