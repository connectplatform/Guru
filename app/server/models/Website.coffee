db = require 'mongoose'
{Schema} = db
{Field} = db.models

website = new Schema

  requiredFields:
    type: [

      name:
        type: String
        required: true

      inputType:
        type: String
        enum: ['text', 'selection']
        required: true

      selections: [String]

      default: String
    ]

  name:
    type: String
    required: true
    index:
      unique: true

  url:
    type: String
    required: true
    index:
      unique: true

  specialties:
    type: [String]
    default: []

  acpEndpoint:
    type: String

  acpApiKey:
    type: String

module.exports = website
