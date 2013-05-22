db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatStatusStates} = config.require 'load/enums'
{getString} = config.require 'load/util'

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

chat.path('_id').get getString
chat.path('accountId').get getString
chat.path('websiteId').get getString
chat.path('specialtyId').get getString

chat.post 'remove', (_chat) ->
  {ChatSession} = db.models
  chatId = _chat._id
  ChatSession.remove {chatId}, (err) ->
    if err?
      config.log.error 'Error cascading remove', {error: err, chatId: chatId}


module.exports = chat