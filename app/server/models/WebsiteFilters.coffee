module.exports =
  createFields: (inModel) ->
    inModel.requiredFields = [
        name: 'username'
        inputType: 'text'
        default: 'Chat Name'
      ,
        name: 'department'
        inputType: 'selection'
        selections: ['Sales', 'Billing']
    ]
    inModel

  filterOutput: (inModel) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt '_id'
    outModel
