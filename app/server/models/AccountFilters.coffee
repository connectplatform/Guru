module.exports =
  createFields: (inModel) -> inModel #TODO: don't call createFields

  filterOutput: (inModel) ->
    # TODO: take this out, it will cause a mismatch if the data is obtained without this filter
    user = {id: inModel['_id']}
    user
