{Specialty} = require('mongoose').models

module.exports =
  required: ['accountId', 'specialties']
  service: ({accountId, specialties}, done) ->
    Specialty.find {accountId: accountId, _id: $in: specialties}, {name: true}, (err, results) ->
      return done 'Could not find specialty name.' if err or not results
      done err, {translated: results.map 'name'}
