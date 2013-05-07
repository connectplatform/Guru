db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

# Session for a logged-in User or non-User visitor
session = new Schema

  accountId:
    type: ObjectId
    required: true

  userId:
    type: ObjectId
    required: false

  chatSessions:
    type: [ObjectId]
    default: []

  username:
    type: String
    required: true

module.exports = session