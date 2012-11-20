module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    #console.log "accountId:", accountId
    getOwner = config.service 'account/getOwner'
    recurlyRequest = config.service 'account/recurlyRequest'

    # find the owner for this account
    getOwner accountId: accountId, (err, owner) ->
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
