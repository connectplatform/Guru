{getType} = config.require 'load/util'

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'

    params =
      method: 'get'
      resource: "accounts/#{accountId}/subscriptions"

    recurlyRequest params, (err, result) ->
      subscription = result?.subscriptions?.subscription
      if getType(subscription) is 'Array'
        subscription = subscription.find (s) -> s.plan.plan_code is 'standard'

      done err, {status: result.status, subscription: subscription}
