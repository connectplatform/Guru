cache = config.require 'load/cache'

module.exports =
  required: ['accountId', 'quantity']
  service: ({accountId, quantity}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'

    params =
      method: 'post'
      resource: "subscriptions"
      rootName: 'subscription'
      modifies: "accounts/#{accountId}/subscriptions"
      body:
        plan_code: 'standard'
        currency: 'USD'
        quantity: quantity
        account:
          account_code: accountId

    recurlyRequest params, done
