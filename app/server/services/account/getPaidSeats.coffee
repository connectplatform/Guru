{Account, User} = require('mongoose').models

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    # is this a paid account?
    Account.findOne {_id: accountId}, (err, account) ->
      return done "Could not find account: #{err}" if err or not account
      return done() if account.accountType isnt 'Paid'

      # get number of paid operators
      User.count {accountId: accountId, role: $ne: 'Owner'}, (err, paidSeats) ->
        return done err if err
        return done null, {paidSeats: paidSeats}
