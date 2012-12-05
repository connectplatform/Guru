mapSpecialties = config.service 'specialties/mapSpecialties'

module.exports =
  createFields: (inModel, next) ->
    mapSpecialties {model: inModel, getter: 'getSpecialtyNames'}, next

  filterOutput: (inModel, next) ->
    # TODO: take this out, it will cause a mismatch if the data is obtained without this filter
    user = {id: inModel['_id']}
    for key, value of inModel._doc when (key isnt 'password' and key isnt '_id')
      user[key] = value

    mapSpecialties {model: user, getter: 'getSpecialtyIds'}, next
