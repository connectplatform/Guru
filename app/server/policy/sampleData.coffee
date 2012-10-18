async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{User, Role, Website, Specialty, Field} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

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
      (cb) -> async.map roles, createRole, cb
      (cb) -> async.map websites, createWebsite, cb
      (cb) -> async.map specialties, createSpecialty, cb
    ], (err) ->

      console.log 'Error preparing seed data; ', err if err

      siteIds = {}
      Website.find {}, (err, websites) ->
        siteIds[website.name] = website._id for website in websites

        createUser = (user, cb) ->
          user.password = digest_s user.password
          sites = (siteIds[siteName] for siteName in user.websites)
          user.websites = sites
          User.create user, cb

        async.map operators, createUser, done
