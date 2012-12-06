{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyNames, done) ->
  Specialty.find {accountId: accountId, name: $in: specialtyNames}, {_id: true}, (err, results) ->
    return done err if err or not results
    done err, results.map '_id'
