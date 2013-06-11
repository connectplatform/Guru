module.exports =
  required: ['accountId', 'modelName']
  optional: ['queryObject']
  service: ({accountId, modelName, queryObject}, done) ->
    queryObject ||= {}

    # inject accountId into query
    if modelName is 'Account'
      queryObject.merge {_id: accountId}
    else
      queryObject.merge {accountId}

    config.services['model/findModel'] {queryObject, modelName}, done
