{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyIds, done) ->
  Specialty.find {accountId: accountId, _id: $in: specialtyIds}, {name: true}, (err, results) ->
    return done 'Could not find specialty name.' if err or not results
    done err, results.map 'name'
