mapSpecialties = config.service 'specialties/mapSpecialties'
cache = config.require 'load/cache'

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

    for imageName in ['logo', 'online', 'offline']
      value = inModel["#{imageName}Uploaded"]
      if value
        cache.store "hasImage/#{inModel._id}/#{imageName}", value

  filterOutput: (inModel, next) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel.toObject(getters: true) when key isnt '_id'
    mapSpecialties {model: outModel, getter: 'getSpecialtyNames'}, next
