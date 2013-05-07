db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{chatStatusStates} = config.require 'load/enums'

chat = new Schema
  chatId:
    type: ObjectId
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
      userId:
        type: ObjectId
        required: false
    ]

module.exports = chat