async = require 'async'

mongo = config.require 'server/load/mongo'
{Account, User, Website, Specialty} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createAccount = (accountId, cb) ->
      Account.create accountId, cb

    createSpecialty = (accountId) ->
      (specialty, cb) ->
        Specialty.create specialty.merge(accountId: accountId), cb

    createUser = (websites, accountId) ->
      (user, cb) ->
        user.accountId = accountId unless user.role is 'Administrator'
        user.websites = websites.filter((site) -> site.url in user.websites).map '_id'
        User.create user, cb

    createWebsite = (accountId) ->
      (website, cb) ->
        Website.create website.merge(accountId: accountId), (err, data) ->
          config.log.warn 'error creating website: ', err if err
          cb err, data

    accounts = [
      status: 'Trial'
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
        websites: ['foo.com']
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
        subdomain: "foo"
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
      ,
        url: "baz.com"
        subdomain: "baz"
        contactEmail: 'success@simulator.amazonses.com'
      ,
        url: "bar.com"
        subdomain: "bar"
        contactEmail: 'success@simulator.amazonses.com'
    ]

    specialties = [ {name: 'Sales'}, {name: 'Billing'}]

    async.map accounts, createAccount, (err, accounts) ->
      return done err if err
      [account] = accounts

      async.parallel {
        websites: (cb) -> async.map websites, createWebsite(account._id), cb
        specialties: (cb) -> async.map specialties, createSpecialty(account._id), cb

      }, (err, data) ->
        async.map operators, createUser(data.websites, account._id), (err, opData) ->

          # return all data created
          done err, data.merge {operators: opData, accounts: accounts}
