{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyNames, done) ->
  Specialty.find {accountId: accountId, name: specialtyNames}, {_id: true}, done
