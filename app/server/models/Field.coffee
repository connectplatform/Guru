db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

module.exports = new Schema

  accountId:
    type: ObjectId
    required: true

  name:
    type: String
    required: true

  inputType:
    type: String
    enum: ['text', 'selection']
    required: true

  selections: [String]

  default: String
