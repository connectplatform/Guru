db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

sendRegistrationEmail = config.require 'services/operator/sendRegistrationEmail'

#TODO: remove duplication
validateRole = (role, cb) ->
  mongo = config.require 'load/mongo'
  {Role} = mongo.models
  Role.find {}, (err, roles) ->
    for validRole in roles
      return cb true if role is validRole.name
    cb false

validateWebsite = (websiteName, cb) ->
  mongo = config.require 'load/mongo'
  {Website} = mongo.models
  Website.find {}, (err, validWebsites) ->
    for validWebsite in validWebsites
      return cb true if websiteName is validWebsite.name
    cb false

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
    validate: [validateRole, "Invalid role"]

  websites:
    type: [String]
    default: []
#TODO:
#    validate: [validateWebsite, "Invalid website"]

  specialties:
    type: [String]
    default: []

user.pre 'save', (next) -> sendRegistrationEmail @, next

module.exports = user
