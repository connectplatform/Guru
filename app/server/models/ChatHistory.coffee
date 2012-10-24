db = require 'mongoose'
{Schema} = db
{Mixed, ObjectId} = Schema.Types

history = new Schema

  accountId:
    type: ObjectId
    required: true

  visitor: Mixed
  operators: [ObjectId]
  website: String
  creationDate: String
  history: [
    message: String
    username: String
    timestamp: String
  ]

module.exports = history
