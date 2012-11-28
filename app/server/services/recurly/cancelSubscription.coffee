module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'
    getSubscription = config.service 'recurly/getSubscription'

    getSubscription {accountId: accountId}, (err, result) ->
      return done err if err or not result
      subscriptionId = result?.subscription?.uuid

      params =
        method: 'put'
        resource: "subscriptions/#{subscriptionId}/cancel"
        modifies: "accounts/#{accountId}/subscriptions"

      recurlyRequest params, done
