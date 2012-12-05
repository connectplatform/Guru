{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyIds, done) ->
  Specialty.find {accountId: accountId, _id: specialtyIds}, {name: true}, done
