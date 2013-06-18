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

# return string, not ObjectId
for field in ['_id', 'sessionId', 'chatId', 'initiator']
  chatSession.path(field).get getString

makePostHook = (event) ->
  (_chatSession) ->
    chatSession.post event, (_chatSession) ->
    {Chat} = db.models
    {chatId} = _chatSession
    
    Chat.findById chatId, (err, chat) ->
      return config.log.error (new Error "Error in ChatSession post '#{event}' hook."), err if err
      return config.log.error (new Error "Chat not found in in ChatSession post '#{event}' hook.") unless chat
      
      chat?.recalculateStatus()

for event in ['save', 'remove']
  chatSession.post event, makePostHook event

module.exports = chatSession