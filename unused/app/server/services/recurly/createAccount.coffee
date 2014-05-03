module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    recurlyRequest = config.service 'recurly/recurlyRequest'
    getOwner = config.service 'account/getOwner'

    getOwner {accountId: accountId}, (err, owner) ->
      return done err if err

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
