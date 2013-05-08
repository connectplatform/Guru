db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatSessionRelations} = config.require 'load/enums'

chatSession = new Schema
  sessionId:
    type: ObjectId
    required: true

  chatId:
    type: ObjectId
    required: true

  creationDate:
    type: Date
    default: Date.now
    required: true

  relation:
    type: String
    enum: chatSessionRelations
    required: true

  initiator: ObjectId

module.exports = chatSession