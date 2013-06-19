db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types
{getString} = config.require 'lib/util'

specialty = new Schema

  accountId:
    type: ObjectId
    required: true

  name:
    type: String
    required: true
    index:
      unique: true

specialty.path('_id').get getString
specialty.path('accountId').get getString

module.exports = specialty
