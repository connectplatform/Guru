async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{Account, User, Role, Website, Specialty, Field} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createAccount = (account, cb) ->
      Account.create account, cb

    createSpecialty = (specialty, cb) ->
      Specialty.create specialty, cb

    createUser = (account) ->
      (user, cb) ->
        user.password = digest_s user.password
        User.create user.merge(accountId: account), cb

    createRole = (account) ->
      (role, cb) ->
        Role.create role.merge(accountId: account), cb

    createWebsite = (account) ->
      (website, cb) ->
        Website.create website.merge(accountId: account), cb

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
        name: "foo.com"
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
    ]

    specialties = [ {name: 'Sales'}, {name: 'Billing'}]

    async.map accounts, createAccount, (err, accounts) ->
      return done err if err
      [account] = accounts

      async.parallel [
        (cb) -> async.map operators, createUser(account), cb
        (cb) -> async.map roles, createRole(account), cb
        (cb) -> async.map websites, createWebsite(account), cb
        (cb) -> async.map specialties, createSpecialty, cb
      ], done
