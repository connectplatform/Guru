mapSpecialties = config.service 'specialties/mapSpecialties'

module.exports =
  createFields: (inModel, next) ->
    mapSpecialties {model: inModel, getter: 'getSpecialtyIds'}, next

  filterOutput: (inModel, next) ->

    # TODO: take this out, it will cause a mismatch if the data is obtained without this filter
    user = {id: inModel['_id']}
    for key, value of inModel.toObject(getters: true) when (key isnt 'password' and key isnt '_id')
      user[key] = value

    mapSpecialties {model: user, getter: 'getSpecialtyNames'}, next
