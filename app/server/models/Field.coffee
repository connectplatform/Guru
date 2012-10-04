db = require 'mongoose'
{Schema} = db

module.exports = new Schema

  name:
    type: String
    required: true

  inputType:
    type: String
    enum: ['text', 'selection']
    required: true

  selections: [String]

  default: String
