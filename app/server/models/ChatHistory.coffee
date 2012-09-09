db = require 'mongoose'
{Schema} = db
{Mixed, ObjectId} = Schema.Types

history = new Schema
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
