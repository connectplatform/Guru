{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyIds, done) ->
  Specialty.find {accountId: accountId, _id: $in: specialtyIds}, {name: true}, (err, results) ->
    return done err if err or not results
    done err, results.map 'name'
