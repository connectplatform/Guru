module.exports =
  required: ['accountId', 'owner']
  service: ({accountId, owner}, done) ->

    recurlyRequest = config.service 'account/recurlyRequest'

    params =
      method: 'post'
      resource: 'accounts'
      rootName: 'account'
      body:
        account_code: accountId
        email: owner.email
        first_name: owner.firstName
        last_name: owner.lastName

    recurlyRequest params, done
