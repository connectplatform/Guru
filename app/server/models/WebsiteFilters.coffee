module.exports =
  createFields: (inModel) ->
    inModel.requiredFields = [
        name: 'username'
        inputType: 'text'
        default: ''
        label: 'Your Name'
      ,
        name: 'department'
        inputType: 'selection'
        selections: ['Sales', 'Billing']
        label: 'Department'
    ]
    inModel

  filterOutput: (inModel) ->
    outModel = {id: inModel['_id']}
    outModel[key] = value for key, value of inModel._doc when key isnt '_id'
    outModel
