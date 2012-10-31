async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{Account, User, Website, Specialty} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createAccount = (account, cb) ->
      Account.create account, cb

    createSpecialty = (account) ->
      (specialty, cb) ->
        Specialty.create specialty.merge(accountId: account), cb

    createUser = (websites, account) ->
      (user, cb) ->
        user.accountId = account unless user.role is 'Administrator'
        user.password = digest_s user.password
        user.websites = websites.filter((site) -> site.url in user.websites).map 'id'
        User.create user, cb

    createWebsite = (account) ->
      (website, cb) ->
        Website.create website.merge(accountId: account), (err, data) ->
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
        websites: (cb) -> async.map websites, createWebsite(account), cb
        specialties: (cb) -> async.map specialties, createSpecialty(account), cb

      }, (err, data) ->
        {websites} = data
        async.map operators, createUser(websites, account), (err, opData) ->

          # return all data created
          done err, data.merge operators: opData
