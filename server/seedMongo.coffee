async = require 'async'
{digest_s} = require 'md5'
mongo = require './mongo'
User = mongo.model 'User'
Role = mongo.model 'Role'
Website = mongo.model 'Website'

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
        password: 'foobar'
        role: 'Administrator'
        firstName: 'Admin'
        lastName: 'Guy'
      ,
        email: 'guru1@foo.com'
        password: 'foobar'
        role: 'Operator'
        firstName: 'First'
        lastName: 'Guru'
      ,
        email: 'guru2@foo.com'
        password: 'foobar'
        role: 'Operator'
        websites: ['test.com']
      ,
        email: 'guru3@foo.com'
        password: 'foobar'
        role: 'Operator'
        websites: ['test.com']
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
        acpEndpoint: "http://localhost:8674"
    ]

    async.parallel [
      (cb) -> async.map operators, createUser, cb
      (cb) -> async.map roles, createRole, cb
      (cb) -> async.map websites, createWebsite, cb
    ], done
