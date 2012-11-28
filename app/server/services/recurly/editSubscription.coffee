module.exports =
  required: ['accountId', 'quantity']
  service: ({accountId, quantity}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'
    getSubscription = config.service 'recurly/getSubscription'

    getSubscription {accountId: accountId}, (err, result) ->
      return done err if err

      subscriptionId = result.subscription.uuid
      status = result.subscription.status
      oldQuantity = result.subscription.quantity.value

      params =
        method: 'put'
        resource: "subscriptions/#{subscriptionId}"
        modifies: "accounts/#{accountId}/subscriptions"
        rootName: 'subscription'
        body:
          timeframe: 'now'
          quantity: quantity

      recurlyRequest params, done
