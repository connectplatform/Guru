async = require 'async'
db = require 'mongoose'
{curry} = config.require 'load/util'
{Account, User} = db.models

login = config.require 'services/login'

module.exports =
  required: ['email', 'firstName', 'lastName', 'password']
  service: (fields, done) ->
    fields.role = 'Owner'
    user = new User fields

    saveUser = (next, {account}) ->
      user.accountId = account.id
      user.save next

    createAccount = (cb) ->
      Account.create {status: 'Trial'}, cb

    async.auto {
      ok: (cb) -> user.validate cb
      account: ['ok', createAccount]
      user: ['account', saveUser]

    }, (err, results) ->
      if err
        config.log.warning "Error creating account: #{err}", fields: fields
        return done err

      loginFields = Object.findAll fields, (k) -> k in ['email', 'password']
      login.service loginFields, done
