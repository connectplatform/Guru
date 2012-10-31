async = require 'async'
db = require 'mongoose'
{curry} = config.require 'load/util'
{Account, User} = db.models

module.exports =
  required: ['fields']
  service: ({fields}, done) ->
    fields.role = 'Owner'
    user = new User
    user.merge fields

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

      {account, user: [user]} = results
      done null, {accountId: account.id, userId: user.id}
