db = require 'mongoose'
{Account, User} = db.models

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    getSubscription = config.service 'recurly/getSubscription'

    Account.findOne {_id: accountId}, {accountType: true}, (err, account) ->
      return done "Couldn't find account.", {goodStanding: false} if err or not account
      return done null, {goodStanding: true} if account.accountType is 'Unlimited'

      User.count {accountId: accountId}, (err, count) ->
        return done "Couldn't find users.", {goodStanding: false} if err or not count
        return done null, {goodStanding: true} if count < 2

        getSubscription {accountId: accountId}, (err, result) ->
          goodStanding = (not err and result?.subscription? and result?.subscription.state isnt 'expired')
          done err, {goodStanding: goodStanding}
