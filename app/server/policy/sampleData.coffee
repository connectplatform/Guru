async = require 'async'
Factory = config.require 'data/factory'

mongo = config.require 'server/load/mongo'
{Account, User, Website, Specialty} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    mapSpecialties = config.service 'specialties/mapSpecialties'

    createAccount = (accountId, cb) ->
      Account.create accountId, cb

    createSpecialty = (accountId) ->
      (specialty, cb) ->
        Specialty.create specialty.merge(accountId: accountId), cb

    createUser = (websites, accountId) ->
      (user, cb) ->
        user.accountId = accountId unless user.role is 'Administrator'
        user.websites = websites.filter((site) -> site.url in user.websites).map '_id'
        mapSpecialties {model: user, getter: 'getSpecialtyIds'}, (err, user) ->
          User.create user, cb

    createPaidOwner = (accountId, next) ->
      createUser([], accountId)({
        email: 'owner@bar.com'
        sentEmail: true
        registrationKey: 'abcd'
        password: 'foobar'
        role: 'Owner'
        firstName: 'Paid'
        lastName: 'Owner'
        websites: []
      }, next)

    createWebsite = (accountId) ->
      (website, cb) ->
        website.merge(accountId: accountId)
        mapSpecialties {model: website, getter: 'getSpecialtyIds'}, (err, website) ->
          config.log.warn 'error finding specialty: ', err if err
          Website.create website, (err, data) ->
            config.log.warn 'error creating website: ', err if err
            cb err, data

    accounts = [
        accountType: 'Unlimited'
      ,
        accountType: 'Paid'
    ]

    operators = [
        email: 'admin@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Administrator'
        firstName: 'Admin'
        lastName: 'Guy'
        websites: []
      ,
        email: 'owner@foo.com'
        sentEmail: true
        registrationKey: 'abcd'
        password: 'foobar'
        role: 'Owner'
        firstName: 'Owner'
        lastName: 'Man'
        websites: []
      ,
        email: 'guru1@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Operator'
        firstName: 'First'
        lastName: 'Guru'
        websites: ['foo.com']
      ,
        email: 'guru2@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Operator'
        firstName: 'Second'
        lastName: 'Guru'
        websites: ['foo.com']
      ,
        email: 'guru3@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Operator'
        firstName: 'Third'
        lastName: 'Guru'
        websites: ['foo.com']
        specialties: ['Sales']
      ,
        email: 'wrongpassword@foo.com'
        sentEmail: true
        password: 'wrongpassword'
        role: 'Operator'
        firstName: 'Wrong'
        lastName: 'Password'
        websites: []
        specialties: []
    ]

    websites = [
        url: "foo.com"
        contactEmail: 'success@simulator.amazonses.com'
        specialties: ['Sales', 'Billing']
        onlineUploaded: true
        offlineUploaded: true
        logoUploaded: true
        requiredFields: [
            name: 'username'
            inputType: 'text'
            defaultValue: ''
            label: 'Your Name'
        ]
      ,
        url: "baz.com"
        contactEmail: 'success@simulator.amazonses.com'
      ,
        url: "bar.com"
        contactEmail: 'success@simulator.amazonses.com'
    ]

    specialties = [ {name: 'Sales'}, {name: 'Billing'}]

    async.auto {
      accounts: (next) -> async.map accounts, createAccount, next
      specialties: ['accounts', (next, {accounts}) -> async.map specialties, createSpecialty(accounts[0]._id), next]
      websites: ['specialties', (next, {accounts}) -> async.map websites, createWebsite(accounts[0]._id), next]
      operators: ['websites', (next, {websites, accounts}) ->
        async.map operators, createUser(websites, accounts[0]._id), next]
      paidOwner: ['accounts', (next, {accounts}) -> createPaidOwner accounts[1]._id, next]
      chatHistory: ['accounts', (next, {accounts}) -> Factory.create 'chathistory', {accountId: accounts[0]._id}, next]
    }, done
