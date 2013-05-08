Factory = require 'factory-worker'
models = config.require('load/mongo').models
{User, Account, Specialty, Website, ChatHistory, Chat, Session, ChatSession} = models
{chatStatusStates} = config.require 'load/enums'

{getString} = config.require 'load/util'
# {Chat, ChatSession, Session} = require('stoic').models

# ================================================================
# helpers
# ================================================================
getSpecialtyIds = config.require 'services/specialties/getSpecialtyIds'

getArray = (fn) ->
  (done) ->
    fn (err, data) ->
      done err, [data]

defaultAccountId = (done) ->
  Account.findOne {accountType: 'Unlimited'}, (err, account) ->
    done err, getString(account._id)

getSpecialties = (list) ->
  (next) ->
    defaultAccountId (err, accountId) ->
      config.services['specialties/getSpecialtyIds'] {accountId: accountId, specialties: list}, next

# ================================================================
# mongo factories
# ================================================================
opcount = 1
Factory.define 'operator', User, {
  accountId: defaultAccountId
  firstName: 'Op'
  lastName: 'Guy'
  email: -> "operator#{opcount++}@bar.com"
  sentEmail: true
  password: 'foobar'
  role: 'Operator'
  specialties: getSpecialties ['Sales']
  websites: []
}

# need: {accountId}
Factory.define 'paidOwner', User, {
  email: 'owner@bar.com'
  sentEmail: true
  registrationKey: 'abcd'
  password: 'foobar'
  role: 'Owner'
  firstName: 'Paid'
  lastName: 'Owner'
  websites: []
}

newOperator = (done) ->
  Factory.create 'operator', (err, op) ->
    done err, op?._id

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

Factory.define 'chathistory', ChatHistory, {
  accountId: defaultAccountId
  visitor: {username: 'sum gai', websiteUrl: 'foo.com', referrerData: '{"username": "sum gai", "websiteUrl": "foo.com"}'}
  operators: getArray newOperator
  website: 'absdfasdf1'
  creationDate: -> new Date
  history: [
      message: 'Hi'
      username: 'sum gai'
      timestamp: -> new Date
    ,
      message: 'Hi back'
      username: 'some op'
      timestamp: -> new Date
  ]
}

Factory.define 'chat', Chat, {
  status: chatStatusStates[0]
  history: []
  websiteId: null
  websiteUrl: null
}

Factory.define 'session', Session, {
  accountId: defaultAccountId
  userId: null
  username: 'Example visitor'
}

Factory.define 'chatSession', ChatSession, {
  sessionId: null
  chatId: null
  relation: 'Member'
}


# ================================================================
# redis factories
# ================================================================
#
# Can't do... need constructor implementation.

module.exports = Factory
