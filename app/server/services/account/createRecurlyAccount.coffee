rest = require 'restler'
easyxml = require 'easyxml'

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->

    getOwner = config.service 'account/getOwner'
    createSubscription = config.service 'account/createSubscription'
    xmlParser = config.require 'load/xmlParser'

    # find the owner for this account
    getOwner accountId: accountId, (err, owner) ->
      return done err if err

      body = easyxml.render {
        account_code: accountId.toString()
        email: owner.email
        first_name: owner.firstName
        last_name: owner.lastName
      }, 'account'

      # submit the account details to recurly
      rest.post(config.recurly.apiUrl + "accounts", {
        parser: xmlParser().parseString
        username: config.recurly.apiKey
        password: ''
        headers:
          'Accept': 'application/xml'
          'Content-Type': 'application/xml'
        data: body

      }).on 'complete', (account, response) =>

        err = if response.statusCode is 201 then null else 'Could not create account.'
        done err, {status: response.statusCode, account: account} #if err

        #createSubscription {accountId: accountId}, (err, subscription) ->
          #done err, data.merge {subscription: subscription}
