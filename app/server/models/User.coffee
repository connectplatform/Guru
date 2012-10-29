db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

enums = config.require 'load/enums'
sendRegistrationEmail = config.require 'services/operator/sendRegistrationEmail'

validateWebsite = (websiteIds, cb) ->
  mongo = config.require 'load/mongo'
  {Website} = mongo.models
  Website.find {accountId: @accountId}, (err, validWebsites) ->
    validIds = validWebsites.map (s) -> s.id
    for websiteId in websiteIds
      return cb false unless websiteId in validIds
    cb true

user = new Schema

  accountId:
    type: ObjectId
    required: true

  sentEmail:
    type: Boolean
    default: false

  registrationKey: String

  firstName:
    type: String
    default: ""

  lastName:
    type: String
    default: ""

  email:
    type: String
    required: true
    index:
      unique: true

  password: String

  role:
    type: String
    required: true
    enum: enums.roles

  websites:
    type: [String]
    default: []
    validate: [validateWebsite, "Invalid website"]

  specialties:
    type: [String]
    default: []

user.pre 'save', (next) -> sendRegistrationEmail @, next

module.exports = user
