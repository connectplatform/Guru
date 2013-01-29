process.env.GURU_PULSAR_PORT = 'DISABLED'

module.exports = ->
  config.require 'load/mongo'
  config.require('load/initServices')()
  sampleData = config.require 'policy/sampleData'

  # run sampleData
  sampleData (err, data) ->
    console.log 'Error: ', err if err?
    console.log "Created #{(records.length or 1 for coll, records of data).reduce((l, r)->l+r)} records."

    #{inspect} = require 'util'
    #console.log "Full data: #{inspect data, null, 1}"

    accountId = data.accounts[0]._id
    owner = data.operators[1]

    # create a recurly account
    createRecurly = config.service "recurly/createAccount"

    createRecurly {accountId: accountId}, (err, status) ->
      console.log "Error creating Recurly account: #{err}" if err
      console.log 'Recurly token:', status.account.hosted_login_token

      process.exit()
