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

  queryData: Mixed # validate is Object in post-validation hook

  formData: Mixed # validate is Object in post-validation hook

  acpData: Mixed # validate is Object in post-validation hook

  visitorData: Mixed

chat.path('_id').get getString
chat.path('accountId').get getString
chat.path('websiteId').get getString
chat.path('specialtyId').get getString

chat.path('visitorData').get () ->
  visitorsDataExists = (@queryData? or @formData? or @acpData?)
  return null unless visitorsDataExists

  visitorData = {}
  visitorData.merge @queryData
  visitorData.merge @formData
  visitorData.merge @acpData
  return visitorData

chat.pre 'save', (next) ->
  isValid = (x) -> (typeof x == 'object') or (not x?)

  err = Error 'queryData must be an Object'
  next err unless isValid @queryData

  err = Error 'formData must be an Object'
  next err unless isValid @formData

  err = Error 'acpData must be an Object'
  next err unless isValid @acpData

  next()

chat.post 'remove', (_chat) ->
  {ChatSession} = db.models
  chatId = _chat._id
  ChatSession.remove {chatId}, (err) ->
    if err?
      config.log.error 'Error cascading remove', {error: err, chatId: chatId}


module.exports = chat
