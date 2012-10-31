db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

website = new Schema

  accountId:
    type: ObjectId
    required: true

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

  url:
    type: String
    required: true
    index:
      unique: true

  subdomain:
    type: String
    required: true
    unique: true

  specialties:
    type: [String]
    default: []

  contactEmail:
    type: [String]
    required: true

  acpEndpoint:
    type: String

  acpApiKey:
    type: String

module.exports = website
