async = require 'async'
{digest_s} = require 'md5'

mongo = config.require 'server/load/mongo'
{User, Role, Website} = mongo.models

module.exports = (done) ->
  mongo.wipe ->

    createUser = (user, cb) ->
      user.password = digest_s user.password
      User.create user, cb

    createRole = (role, cb) ->
      Role.create role, cb

    createWebsite = (website, cb) ->
      Website.create website, cb

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
      ,
        email: 'guru2@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Operator'
        websites: ['foo.com']
      ,
        email: 'guru3@foo.com'
        sentEmail: true
        password: 'foobar'
        role: 'Operator'
        websites: ['foo.com']
        specialties: ['Sales']
    ]

    roles = [
        {name: "Administrator"}
        {name: "Operator"}
        {name: "Supervisor"}
    ]

    websites = [
        name: "example.com"
        url: "http://www.example.com"
        acpEndpoint: "http://localhost:8675"
        acpApiKey: "QWxhZGRpbjpvcGVuIHNlc2FtZQ=="
    ]

    async.parallel [
      (cb) -> async.map operators, createUser, cb
      (cb) -> async.map roles, createRole, cb
      (cb) -> async.map websites, createWebsite, cb
    ], done
