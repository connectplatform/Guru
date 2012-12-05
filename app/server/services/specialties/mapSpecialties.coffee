async = require 'async'

module.exports = ({model, getter}, next) ->
  unless model.specialties.isEmpty()
    getter = config.service "specialties/#{getter}"
    async.map model.specialties, getter, (err, specialtyIds) ->
      model.specialties = specialtyIds
      next null, model

  else
    next null, model
