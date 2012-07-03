mongo = require '../../server/mongo'
{digest_s} = require 'md5'
User = mongo.model 'User'

module.exports = (cb)->
  mongo.wipe ->
    createUser = (user, cb) ->
      user.password = digest_s user.password
      User.create user, cb

    operator = 
      email: 'god@torchlightsoftware.com'
      password: 'foobar'
      role: 'admin'
      firstName: 'God'

    createUser operator, cb