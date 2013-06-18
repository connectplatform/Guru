db = require 'mongoose'
{Account, Session, User} = db.models

module.exports =
  required: ['accountId']
  optional: ['accountId', 'sessionSecret']
  service: ({accountId, sessionId}, done) ->
    if accountId?
      getSubscription = config.service 'recurly/getSubscription'
      Account.findById accountId, (err, account) ->
        return done "Couldn't find account.", {goodStanding: false} if err or not account
        return done null, {goodStanding: true} if account.accountType is 'Unlimited'

        User.count {accountId: accountId}, (err, count) ->
          return done "Couldn't find users.", {goodStanding: false} if err or not count
          return done null, {goodStanding: true} if count < 2

          getSubscription {accountId: accountId}, (err, result) ->
            goodStanding = (not err and result?.subscription? and result?.subscription.state isnt 'expired')
            done err, {goodStanding: goodStanding}
    else
      Session.findById sessionId, (err, session) ->
        {accountId} = session
        config.services['recurly/accountInGoodStanding'] {accountId}, done