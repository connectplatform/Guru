db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

specialty = new Schema

  accountId: ObjectId

  name:
    type: String
    required: true
    index:
      unique: true

module.exports = specialty
