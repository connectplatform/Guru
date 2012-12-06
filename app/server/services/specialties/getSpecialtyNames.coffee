{Specialty} = require('mongoose').models

module.exports = (accountId, specialtyIds, done) ->
  Specialty.find {accountId: accountId, _id: $in: specialtyIds}, {name: true}, (err, results) ->
    console.log 'yo err:', err if err
    return done err if err or not results
    done err, results.map 'name'
