async = require 'async'
{digest_s} = require 'md5'
mongo = require './mongo'
User = mongo.model 'User'
Role = mongo.model 'Role'

module.exports = (done)->
  mongo.wipe ->

    createUser = (user, cb) ->
      user.password = digest_s user.password
      User.create user, cb

    createRole = (role, cb) ->
      Role.create role, cb

    operators = [
        email: 'god@torchlightsoftware.com'
        password: 'foobar'
        role: 'Admin'
        firstName: 'God'
      ,
        email: 'guru1@torchlightsoftware.com'
        password: 'foobar'
        role: 'Operator'
        firstName: 'First'
        lastName: 'Guru'
      ,
        email: 'guru2@torchlightsoftware.com'
        password: 'foobar'
        role: 'Operator'
        websites: 'test.com'
      ,
        email: 'guru3@torchlightsoftware.com'
        password: 'foobar'
        role: 'Operator'
        websites: 'test.com'
        departments: 'Sales'
    ]

    roles = [
        {name: "Admin"}
        {name: "Operator"}
    ]

    async.parallel [
      (cb) -> async.map operators, createUser, cb
      (cb) -> async.map roles, createRole, cb
    ], done
