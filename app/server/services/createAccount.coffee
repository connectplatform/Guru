async = require 'async'
db = require 'mongoose'
{curry} = config.require 'load/util'
{Account, User} = db.models

module.exports =
  required: ['email', 'firstName', 'lastName', 'password']
  service: (fields, done, processSideEffects) ->

    login = config.service 'login'
    createRecurlyAccount = config.service 'account/createRecurlyAccount'

    fields.role = 'Owner'
    user = new User fields

    saveUser = (next, {account}) ->
      console.log 'accountId:', account._id
      user.accountId = account._id
      user.save next

    createAccount = (cb) ->
      Account.create {status: 'Trial'}, cb

    createRecurly = (cb, {account}) ->
      createRecurlyAccount {accountId: account._id}, cb

    async.auto {
      ok: (cb) -> user.validate cb
      account: ['ok', createAccount]
      user: ['account', saveUser]
      recurlyAccount: ['account', 'user', createRecurly]

    }, (err, results) ->
      if err
        config.log.warning "Error creating account: #{err}", fields: fields
        return done err

      loginFields = Object.findAll fields, (k) -> k in ['email', 'password']
      login loginFields, done, processSideEffects
