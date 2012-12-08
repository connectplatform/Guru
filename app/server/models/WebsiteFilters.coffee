mapSpecialties = config.service 'specialties/mapSpecialties'

module.exports =
  createFields: (inModel, next) ->
    if inModel.isNew and inModel.requiredFields.isEmpty()
      inModel.requiredFields = [
          name: 'username'
          inputType: 'text'
          default: ''
          label: 'Your Name'
      ]
    mapSpecialties {model: inModel, getter: 'getSpecialtyIds'}, next

  filterOutput: (inModel, next) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt '_id'
    mapSpecialties {model: outModel, getter: 'getSpecialtyNames'}, next
