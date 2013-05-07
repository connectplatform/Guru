# Session for a logged-in User or non-User visitor

db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

session = new Schema
  sessionId:
    type: ObjectId
    required: true

  accountId:
    type: ObjectId
    required: true

  userId:
    type: ObjectId
    required: false

  chatSessions:
    type: [ObjectId]
    required: true

  username:
    type: String
    required: true
