{Specialty} = require('mongoose').models

module.exports =
  required: ['accountId', 'specialties']
  service: ({accountId, specialties}, done) ->
    Specialty.find {accountId: accountId, name: $in: specialties}, {_id: true}, (err, results) ->
      return done err if err or not results
      done err, {translated: results.map '_id'}
