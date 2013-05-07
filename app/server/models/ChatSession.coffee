db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

chatSession = new Schema
  chatSessionId:
    type: ObjectId
    required: true

  accountId:
    type: ObjectId
    required: true

  sessionId:
    type: ObjectId
    required: true

  chatId:
    type: ObjectId
    required: true

  websiteId: String

  websiteUrl: String

  specialtyId: String

  creationDate:
    type: Date
    required: true

  isWatching:
    type: Boolean
    required: true

  relation:
    type: String
    enum: 'Member Invite Transfer'.split(' ')
    required: true

  requestor:
    type: ObjectId
    required: false

module.exports = chatSession