db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

{getString} = config.require 'load/util'

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
      label: String
    ]

  url:
    type: String
    required: true
    index:
      unique: true

  # resources uploaded to AWS
  logoUploaded: Boolean
  onlineUploaded: Boolean
  offlineUploaded: Boolean

  specialties:
    type: [String]
    default: []

  contactEmail:
    type: [String]
    required: true
    default: ''

  acpEndpoint:
    type: String
    default: ''

  acpApiKey:
    type: String
    default: ''

website.path('_id').get getString
website.path('accountId').get getString

module.exports = website
