db = require 'mongoose'
{Account} = db.models

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    getSubscription = config.service 'recurly/getSubscription'

    Account.findOne {_id: accountId}, {accountType: true}, (err, account) ->
      return done "Couldn't find account.", false if err or not account
      return done null, true if account.accountType is 'Unlimited'

      getSubscription {accountId: accountId}, (err, result) ->
        goodStanding = (not err and result?.subscription? and result?.subscription.state isnt 'expired')
        done err, goodStanding
