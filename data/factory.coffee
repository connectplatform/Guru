Factory = require 'factory-worker'
{User, Account, Specialty, Website} = config.require('load/mongo').models

defaultAccountId = (done) ->
  Account.findOne {accountType: 'unlimited'}, done

opcount = 1
Factory.define 'operator', User, {
    firstName: 'Op'
    lastName: 'Guy'
    email: -> "operator#{opcount++}@bar.com"
    sentEmail: true
    password: 'foobar'
    role: 'Operator'
    specialties: ['Sales']
    websites: []
  }

siteCount = 1
Factory.define 'website', Website, {
    url: -> "website#{siteCount++}.com"
    contactEmail: 'success@simulator.amazonses.com'
    acpEndpoint: "http://localhost:8675"
    acpApiKey: "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
    requiredFields: [
        name: 'username'
        inputType: 'text'
        default: ''
        label: 'Your Name'
      ,
        name: 'department'
        inputType: 'selection'
        selections: ['Sales', 'Billing']
        label: 'Department'
    ]
  }

module.exports = Factory
