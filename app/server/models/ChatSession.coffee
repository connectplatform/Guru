db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatSessionRelations} = config.require 'load/enums'
{getString} = config.require 'load/util'

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

chatSession.path('_id').get getString
chatSession.path('sessionId').get getString
chatSession.path('chatId').get getString
chatSession.path('initiator').get getString

# chatSession.pre 'remove', (next) ->
#   console.log 'removing a ChatSession'
#   next()

module.exports = chatSession