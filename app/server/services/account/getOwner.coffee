db = require 'mongoose'
{User} = db.models

module.exports =
  required: ['accountId']
  service: ({accountId}, done) ->
    User.findOne {accountId: accountId, role: 'Owner'}, done
