db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

specialty = new Schema

  accountId:
    type: ObjectId
    required: true

  name:
    type: String
    required: true
    index:
      unique: true

module.exports = specialty
