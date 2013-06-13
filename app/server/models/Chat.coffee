db = require 'mongoose'
{Schema} = db
{ObjectId, Mixed} = Schema.Types
{chatStatusStates} = config.require 'load/enums'
{getString} = config.require 'load/util'
querystring = require 'querystring'

isObject = (value) ->
  (typeof value) is 'object' and not Array.isArray(value)

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

  queryData:
    type: Mixed
    default: {}
    validate: isObject

  formData:
    type: Mixed
    default: {}
    validate: isObject

  acpData:
    type: Mixed
    default: {}
    validate: isObject

# return string, not ObjectID
for field in ['_id', 'accountId', 'websiteId', 'specialtyId']
  chat.path(field).get getString

chat.virtual('visitorData').get ->
  return {}.merge(@queryData).merge(@formData).merge(@acpData)

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
