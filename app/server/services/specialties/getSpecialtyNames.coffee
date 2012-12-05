{Specialty} = require('mongoose').models

module.exports = (specialtyIds, done) ->
  Specialty.find {_id: specialtyIds}, {name: true}, done
