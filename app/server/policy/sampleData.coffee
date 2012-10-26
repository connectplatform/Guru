async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{Account, User, Role, Website, Specialty} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createAccount = (account, cb) ->
      Account.create account, cb

    createRole = (role, cb) ->
      Role.create role, cb

    createSpecialty = (account) ->
      (specialty, cb) ->
        Specialty.create specialty.merge(accountId: account), cb

    createUser = (account) ->
      (user, cb) ->
        user.accountId = account
        user.password = digest_s user.password
        Website.find {accountId: account}, (err, websites) ->
          siteIds = {}
          siteIds[website.url] = website._id for website in websites
          sites = (siteIds[siteUrl] for siteUrl in user.websites)
          user.websites = sites
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
        registrationKey: 'abcd'
        password: 'foobar'
        role: 'Administrator'
        firstName: 'Admin'
        lastName: 'Guy'
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
    ]

    roles = [
        {name: "Administrator"}
        {name: "Operator"}
        {name: "Supervisor"}
    ]

    websites = [
        url: "foo.com"
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
      ,
        url: "bar.com"
    ]

    specialties = [ {name: 'Sales'}, {name: 'Billing'}]

    async.map accounts, createAccount, (err, accounts) ->
      return done err if err
      [account] = accounts

      async.parallel [
        (cb) -> async.map roles, createRole, cb
        (cb) -> async.map websites, createWebsite(account), cb
        (cb) -> async.map specialties, createSpecialty(account), cb
      ], ->
        async.map operators, createUser(account), (err, data) ->
          done err, data
