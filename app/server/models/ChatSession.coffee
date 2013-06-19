db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatSessionRelations} = config.require 'load/enums'
{getString} = config.require 'lib/util'

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

# return string, not ObjectId
for field in ['_id', 'sessionId', 'chatId', 'initiator']
  chatSession.path(field).get getString

# TODO: Trigger recalculateStatus on relevant events.

module.exports = chatSession
