{digest_s} = require 'md5'

db = require 'mongoose'
{Schema} = db
{ObjectId} = Schema.Types

enums = config.require 'load/enums'
{getType, getString} = config.require 'load/util'

validateWebsite = (websiteIds, cb) ->
  mongo = config.require 'load/mongo'
  {Website} = mongo.models
  Website.find {accountId: @accountId}, (err, validWebsites) ->
    validIds = validWebsites.map (s) -> s.id
    for websiteId in websiteIds
      return cb false unless websiteId in validIds
    cb true

validateAccountId = (accountId) ->
  @role is 'Administrator' or @accountId?

# sync recurly subscription on create/delete
paidSeatsChanged = (num, next) ->
  if @role not in ['Owner', 'Administrator']

    #config.log "updating paid seats for: #{@email}"
    config.services['account/updatePaidSeats'] {accountId: @accountId.toString(), newSeats: num}, (err, status) =>
      if err
        config.log.warn "Could not update paid seats: #{err}", {status: status, accountId: @accountId.toString()}

        # Watch out! Any non-errors will cause the callback to never execute!
        err = new Error "Could not update paid seats, please check your billing information."

      next err

  else
    next()

user = new Schema

  accountId:
    type: ObjectId
    validate: [validateAccountId, 'accountId required']

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

user.path('_id').get getString
user.path('accountId').get getString

user.pre 'save', (next) ->
  @password = digest_s @password if @isModified 'password'
  next()


# sync subscriptions on save and delete
user.pre 'save', (next) ->
  if @isNew
    paidSeatsChanged.call @, 1, next
  else
    next()

user.pre 'remove', (next) ->
  paidSeatsChanged.call @, -1, next

user.pre 'save', (next) ->
  sendRegistrationEmail = config.service 'operator/sendRegistrationEmail'
  sendWelcomeEmail = config.service 'owner/sendWelcomeEmail'

  return next new Error "Cannot change #{@oldRole} role." if @oldRole in ['Owner', 'Administrator'] and @isModified 'role'
  if @role in ['Owner', 'Administrator'] and @oldRole in enums.editableRoles and @isModified 'role'
    return next new Error "Cannot make user a #{@oldRole}."

  if @isNew and @role is 'Owner'
    return sendWelcomeEmail @, next

  if @role isnt 'Administrator'
    return sendRegistrationEmail @, next

  next()

user.methods.comparePassword = (password) ->
  @password is digest_s password

module.exports = user
