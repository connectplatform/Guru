async = require 'async'
{digest_s} = require 'md5'
mongo = require '../../server/mongo'
User = mongo.model 'User'
Role = mongo.model 'Role'

module.exports = (cb)->
  mongo.wipe ->
    createUser = (user, cb) ->
      user.password = digest_s user.password
      User.create user, cb

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
    ]

    async.forEach operators, createUser, ->
      Role.create {name: "Operator"}, cb