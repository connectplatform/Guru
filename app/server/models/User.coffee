{digest_s} = require 'md5'

db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

enums = config.require 'load/enums'

validateWebsite = (websiteIds, cb) ->
  mongo = config.require 'load/mongo'
  {Website} = mongo.models
  Website.find {accountId: @accountId}, (err, validWebsites) ->
    validIds = validWebsites.map (s) -> s.id
    for websiteId in websiteIds
      return cb false unless websiteId in validIds
    cb true

validateAccountId = (accountId, cb) ->
  cb @role is 'Administrator' or @accountId

user = new Schema

  accountId:
    type: ObjectId
    validate: [validateAccountId, 'accountId required' ]

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
  @password = digest_s @password if @isModified 'password'
  next()

user.pre 'save', (next) ->

  # if new, create/modify recurly account
  if @isNew and @role not in ['Owner', 'Administrator']

    #config.log "updating paid seats for: #{@email}"
    updatePaidSeats = config.service 'account/updatePaidSeats'
    updatePaidSeats {accountId: @accountId.toString(), newSeats: 1}, (err, status) =>
      config.log.warn "Could not update paid seats: #{err}", {status: status, accountId: @accountId.toString()} if err

      next()

  else
    next()

user.pre 'save', (next) ->
  sendRegistrationEmail = config.service 'operator/sendRegistrationEmail'

  return next new Error "Cannot change #{@oldRole} role." if @oldRole in ['Owner', 'Administrator'] and @isModified 'role'
  if @role in ['Owner', 'Administrator'] and @oldRole in enums.editableRoles and @isModified 'role'
    return next new Error "Cannot make user a #{@oldRole}."
  sendRegistrationEmail @, next

user.methods.comparePassword = (password) ->
  @password is digest_s password

module.exports = user
