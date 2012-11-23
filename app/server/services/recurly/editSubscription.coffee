module.exports =
  required: ['accountId', 'quantity']
  service: ({accountId, quantity}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'
    getSubscription = config.service 'recurly/getSubscription'

    getSubscription {accountId: accountId}, (err, result) ->
      return done err if err
      subscriptionId = result.subscription.uuid

      params =
        method: 'put'
        resource: "subscriptions/#{subscriptionId}"
        rootName: 'subscription'
        body:
          timeframe: 'now'
          quantity: quantity

      recurlyRequest params, done
