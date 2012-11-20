module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    recurlyRequest = config.service 'account/recurlyRequest'

    params =
      method: 'get'
      resource: "accounts/#{accountId}"

    recurlyRequest params, done
