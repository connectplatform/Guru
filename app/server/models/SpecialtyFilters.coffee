module.exports =
  createFields: (inModel, next) -> next null, inModel

  filterOutput: (inModel, next) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt '_id'
    next null, outModel
