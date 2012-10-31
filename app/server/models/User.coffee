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
    validation: ->
      @role is 'Administrator' or accountId

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
    enum: enums.staffRoles

  websites:
    type: [String]
    default: []
    validate: [validateWebsite, "Invalid website"]

  specialties:
    type: [String]
    default: []

user.path('role').set (newVal) ->
  @oldRole = @role
  newVal

user.pre 'save', (next) ->
  return next new Error "Cannot change #{@oldRole} role." if @oldRole in ['Owner', 'Administrator'] and @isModified 'role'
  return next new Error "Cannot make user a #{@oldRole}." if @role in ['Owner', 'Administrator'] and @isModified 'role'
  sendRegistrationEmail @, next

module.exports = user
