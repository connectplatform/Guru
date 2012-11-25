async = require 'async'
db = require 'mongoose'
{curry, select} = config.require 'load/util'
{Account, User} = db.models

module.exports =
  required: ['email', 'firstName', 'lastName', 'password']
  service: (fields, done, processSideEffects) ->

    login = config.service 'login'
    createRecurlyAccount = config.service 'recurly/createAccount'

    fields.role = 'Owner'
    owner = new User fields

    saveOwner = (next, {account}) ->
      owner.accountId = account._id
      owner.save (err, userData) ->
        next err, select(userData._doc, '_id', 'email', 'firstName', 'lastName')

    createAccount = (cb) ->
      Account.create {accountType: 'Paid'}, cb

    createRecurly = (cb, {account, owner}) ->
      createRecurlyAccount {accountId: account._id, owner: owner}, cb

    async.auto {
      ok: (cb) -> owner.validate cb
      account: ['ok', createAccount]
      owner: ['account', saveOwner]
      recurlyAccount: ['account', 'owner', createRecurly]

    }, (err, results) ->
      if err
        config.log.warning "Error creating account: #{err}", fields: fields
        return done err

      loginFields = Object.findAll fields, (k) -> k in ['email', 'password']
      login loginFields, done, processSideEffects
