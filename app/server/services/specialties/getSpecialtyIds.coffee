{Specialty} = require('mongoose').models

module.exports = (specialtyNames, done) ->
  Specialty.find {name: specialtyNames}, {_id: true}, done
