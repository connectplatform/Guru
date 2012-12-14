Factory = require 'factory-worker'
{User, Account, Specialty, Website} = config.require('load/mongo').models

getSpecialtyIds = config.require 'services/specialties/getSpecialtyIds'

defaultAccountId = (done) ->
  Account.findOne {accountType: 'unlimited'}, done

getSpecialties = (list) ->
  (next) ->
    defaultAccountId (err, accountId) ->
      getSpecialtyIds accountId, list, next

opcount = 1
Factory.define 'operator', User, {
    firstName: 'Op'
    lastName: 'Guy'
    email: -> "operator#{opcount++}@bar.com"
    sentEmail: true
    password: 'foobar'
    role: 'Operator'
    specialties: getSpecialties ['Sales']
    websites: []
  }

siteCount = 1
Factory.define 'website', Website, {
    url: -> "website#{siteCount++}.com"
    contactEmail: 'success@simulator.amazonses.com'
    acpEndpoint: "http://localhost:8675"
    acpApiKey: "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
    specialties: getSpecialties ['Sales', 'Billing']
    requiredFields: [
        name: 'username'
        inputType: 'text'
        defaultValue: ''
        label: 'Your Name'
    ]
  }

module.exports = Factory
