seed = config.require 'policy/sampleData'
config.require('load/initServices')()

module.exports = ->

  # run seed data
  seed (err, data) ->
    return console.log 'Error: ', err if err?
    console.log "Created #{(records.length for coll, records of data).reduce((l, r)->l+r)} records."

    #{inspect} = require 'util'
    #console.log "Full data: #{inspect data, null, 1}"

    accountId = data.accounts[0]._id
    owner = data.operators[1]

    # create a recurly account
    createRecurly = config.service "recurly/createAccount"

    createRecurly {accountId: accountId}, (err, status) ->
      return console.log "Error creating Recurly account: #{err}" if err
      console.log 'Recurly token:', status.account.hosted_login_token

      process.exit()
