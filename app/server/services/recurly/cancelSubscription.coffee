module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'
    getSubscription = config.service 'recurly/getSubscription'

    getSubscription {accountId: accountId}, (err, result) ->
      return done err if err
      subscriptionId = result.subscription.uuid

      params =
        method: 'put'
        resource: "subscriptions/#{subscriptionId}/cancel"

      recurlyRequest params, done
