db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatStatusStates} = config.require 'load/enums'

chat = new Schema
  accountId:
    type: ObjectId
    required: true

  status:
    type: String
    required: true
    enum: chatStatusStates

  history:
    type: [
      message:
        type: String
        required: true
      timestamp:
        type: Date
        required: true
      username:
        type: String
        required: true
      userId: ObjectId
    ]

  creationDate:
    type: Date
    default: Date.now
    required: true

  websiteId:
    type: ObjectId
    required: true
    
  websiteUrl:
    type: String
    required: true
    
  specialtyId: ObjectId

module.exports = chat