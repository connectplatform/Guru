module.exports =
  createFields: (inModel) -> inModel

  filterOutput: (inModel) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt '_id'
    outModel
