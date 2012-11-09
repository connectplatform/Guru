module.exports =
  createFields: (inModel) -> inModel #TODO: don't call createFields

  filterOutput: (inModel) ->
    # TODO: take this out, it will cause a mismatch if the data is obtained without this filter
    inModel.merge {id: delete inModel['_id']}
