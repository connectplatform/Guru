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
  (done) ->
    defaultAccountId (err, accountId) ->
      config.services['specialties/getSpecialtyIds'] {accountId: accountId, specialties: list}, done

getWebsiteId = (websiteUrl) ->
  (done) ->
    config.services['websites/getWebsiteIdForDomain'] {websiteUrl}, (err, {websiteId}) ->
      done err, websiteId

Factory.assemble = (name, args) ->
  (done) -> Factory.create name, args, (err, obj) ->
    done err, obj?._id

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
ownerCount = 1
Factory.define 'owner', User, {
  email: -> "owner@baz#{ownerCount++}.com"
  sentEmail: true
  registrationKey: 'abcd'
  password: 'foobar'
  role: 'Owner'
  firstName: 'Paid'
  lastName: 'Owner'
  websites: []
}

# need: {accountId}
Factory.define 'paidOwner', 'owner', {
  email: 'owner@bar.com'
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
  accountId: defaultAccountId
  status: chatStatusStates[0]
  history: []
  websiteId: getWebsiteId 'foo.com'
  websiteUrl: 'foo.com'
}

Factory.define 'session', Session, {
  accountId: defaultAccountId
  userId: null
  username: 'Example visitor'
}

Factory.define 'chatSession', ChatSession, {
  sessionId: Factory.assemble 'session'
  chatId: Factory.assemble 'chat'
  relation: 'Member'
}

Factory.define 'account', Account, {
  accountType: 'Unlimited'
}

module.exports = Factory
