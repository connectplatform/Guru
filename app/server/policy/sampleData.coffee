async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{User, Role, Website, Specialty, Field} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createUser = (user, cb) ->
      user.password = digest_s user.password
      User.create user, cb

    createRole = (role, cb) ->
      Role.create role, cb

    createWebsite = (website, cb) ->
      Website.create website, cb

    createSpecialty = (specialty, cb) ->
      Specialty.create specialty, cb

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

    async.parallel [
      (cb) -> async.map operators, createUser, cb
      (cb) -> async.map roles, createRole, cb
      (cb) -> async.map websites, createWebsite, cb
      (cb) -> async.map specialties, createSpecialty, cb
    ], done
