db = require 'mongoose'
{Schema} = db
{ObjectId, Mixed} = Schema.Types
{chatStatusStates} = config.require 'load/enums'
{getString} = config.require 'load/util'
querystring = require 'querystring'

chat = new Schema
  name:
    type: String
    required: true

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

  queryData: Mixed

  formData: Mixed
  
  acpData: Mixed
  
  visitorData: Mixed

chat.path('_id').get getString
chat.path('accountId').get getString
chat.path('websiteId').get getString
chat.path('specialtyId').get getString

chat.path('queryData').set (value) ->
  if typeof value == 'string'
    return querystring.parse value
  else
    return value

chat.path('acpData').set (value) ->
  if typeof value == 'string'
    return JSON.parse value
  else
    return value

chat.path('visitorData').get () ->
  visitorData = {}
  visitorData.merge @queryData
  visitorData.merge @formData
  visitorData.merge @acpData
  return visitorData

chat.post 'remove', (_chat) ->
  {ChatSession} = db.models
  chatId = _chat._id
  ChatSession.remove {chatId}, (err) ->
    if err?
      config.log.error 'Error cascading remove', {error: err, chatId: chatId}


module.exports = chat