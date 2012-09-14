module.exports =
  createFields: (inModel) -> inModel #TODO: don't call createFields

  filterOutput: (inModel) ->
    # TODO: take this out, it will cause a mismatch if the data is obtained without this filter
    user = {id: inModel['_id']}
    for key, value of inModel._doc when (key isnt 'password' and key isnt '_id')
      user[key] = value

    user
