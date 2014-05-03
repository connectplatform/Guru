module.exports =
  required: ['accountId', 'billingInfo']
  service: ({accountId, billingInfo}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'

    params =
      method: 'put'
      resource: "accounts/#{accountId}/billing_info"
      rootName: 'billing_info'
      body: billingInfo

    recurlyRequest params, done
